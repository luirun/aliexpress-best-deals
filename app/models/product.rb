=begin
  ------------------------- NAVIGATION -------------------
  1 - Create products section
    1.1 - Saving all products found by Aliexpress Api - /admin/form
    1.2 - Find details of found product and save their category and subcategory
  
  2 - Add product details
  3 - Delete unapproved products found in search products form - /admin/form -> /admin/product_list [POST]
  4 - Clear expired products
  5 - Various helper methods
  --------------------------- END -----------------------
=end

class Product < ApplicationRecord
  belongs_to :subcategory

  scope :hot_products, -> { where(is_hot: "y")}
  scope :recommended_products, -> (product) { where(:category_id => product.category_id).limit(12)}
  # scope for not depreciated random method
  # scope :random, -> { order(Arel::Nodes::NamedFunction.new('RANDOM', [])) }

  #--------------------------------------------------
  # 1 - CREATE PRODUCTS METHODS

  # 1.1 - Saving all products found by Aliexpress Api - /admin/form
  def self.ali_new(products, category_id)
    if products.length.zero? # checking that there is one or more products
      return nil # flash some error action
    else
      logger.info("We have found #{products.length} products")
      products.each do |i|
        id_exist = Product.find_by(productId: i["productId"].to_s)
        if !id_exist.nil?
          logger.info("Product Already Exists")
        else
          a = i["30daysCommission"]
          i = i.except("30daysCommission")
          product = Product.new(i)
          product.salePrice = i["salePrice"].slice(4..12)
          product.productTitle = ActionView::Base.full_sanitizer.sanitize(i["productTitle"])
          product.originalPrice = i["originalPrice"].slice(4..12)
          product.thirtydaysCommission = a
          product.is_approved = "n"
          product.category_id = category_id
          product.save
        end
      end
      return "Products successfully saved!"
    end
  end

  # 1.2 - Find details of found product and save their category and subcategory
  # method for mass saving products founded by crawler - works well for saving from file and iterating through the categories
  def self.save_hot_products(products, category_id, subcategory_id)
    fields = %w[productId productTitle productUrl imageUrl
                originalPrice salePrice discount evaluateScore
                commission commissionRate 30daysCommission volume
                packageType lotNum validTime storeName storeUrl]
    products.each do |i|
      details = AliCrawler.new.get_product_details(fields, i["productId"]) # gettig all details about product from hot product list
      if details["result"].nil?
        logger.info("We have not found any details about #{product.productTitle}.")
      else
        id_exist = Product.find_by(productId: i["productId"])
        if !id_exist.nil?
          logger.info("Product Already Exists")
        else
          details = details["result"]
          a = details["30daysCommission"]
          i = details.except("30daysCommission")
          promotion_link = AliCrawler.new.get_promotion_links(i["productUrl"]) # getting promotion url from aliexpress
          promotion_link = promotion_link["result"]["promotionUrls"] # shortening our hash a little
          product = Product.new(i) # making new instance in Hot Products table
          product.salePrice = i["salePrice"].slice(4..12)
          product.originalPrice = i["originalPrice"].slice(4..12)
          product.promotionUrl = promotion_link[0]["promotionUrl"] # saving promotion url to record
          product.thirtydaysCommission = a # adding 30 days commission to record
          product.category_id = category_id
          product.subcategory_id = subcategory_id
          product.is_hot = "y"
          product.is_approved = "y"
          product.save
        end
      end
    end
  end

  #---------------------------- 1 - END ------------------------

  # 2 - Add product details
  def self.save_product_description(product_description, product_id)
    product = Product.find(product_id)
    product.productDescription = product_description
    product.save
  end

  def self.add_promotion_links(promotion_urls, products)
    if promotion_urls[1].nil? # if there is only one product
      products.each do |product|
        product = Product.find(product.id)
        product.promotionUrl = promotion_urls[0]["promotionUrl"]
        product.save
      end
    else # if there is many products
      i = 0
      products.each do |product|
        product = Product.find(product.id)
        product.promotionUrl = promotion_urls[i]["promotionUrl"]
        logger.info(promotion_urls[i]["promotionUrl"])
        product.save
        i += 1
      end
    end
  end
  #------------------------------- 2 - END ------------------------

  # 3 - delete unapproved products found in search products form - /admin/form -> /admin/product_list [POST]
  def self.clear_unwanted_products(products)
    # approving all checked products
    if products.nil?
      logger.info("There is no products to approve")
    else
      products.each do |p|
        product = Product.find_by(productId: p)
        product.is_approved = "y"
        product.save
      end
    end

    # deleting unselected products
    a = Product.all.limit(40).order("id desc")
    a.each do |product|
      product.delete if product.is_approved != "y"
    end
  end
  #--------------------------- 3 - END -------------------------

  # 4 - Clear expired products
  def self.clear_expired_products
    products = Product.where("validTime < '#{Time.zone.now.strftime('%Y-%m-%d')}'")
    products.each do |product|
      product.archived = "y"
      product.save
    end
  end
  # -------------------------- 4 - END ---------------------------------

  # 5 - Various helper methods
  def self.transform_price
    products = Product.where("salePrice like '%us%'")
    products.each do |product|
      product.salePrice = product.salePrice.slice(4..12)
      product.originalPrice = product.salePrice.slice(4.12)
      product.save
    end
  end
  # ------------------------ 5 - END -----------------------------------

  # 6 - Logic from controller
  def self.find_product(product_title)
    product = Product.where("productTitle LIKE ?", product_title).first
  end

  def self.save_from_file(keywords, category)
    keywords.each do |keyword|
      products = AliCrawler.new.search_for_category_products(keyword, category)
      Product.save_hot_products(@products["result"]["products"], category)
    end
  end

  # ------- 6 - END -----------
end



