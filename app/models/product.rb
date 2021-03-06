class Product < ApplicationRecord
  belongs_to :subcategory
  belongs_to :category
  has_many :productLike

  scope :hot_products, -> { where(is_hot: "y") }
  scope :recommended_products, ->(product) { where(category_id: product).limit(12) }
  scope :all_from_brand, ->(product) { where("productTitle like ?", "%#{product.extract_product_brand}%").where(category_id: product.category_id) }
  scope :like_title, ->(title) { find_by("productTitle LIKE ?", title) }
  scope :delete_without_category, -> { where('category_id not in (?)', Category.pluck(:id).delete_all) }
  scope :expired_products, -> { where("validTime < '#{Time.zone.now.strftime('%Y-%m-%d')}'") }

  # Saving all products
  def self.new_product(products, category_id)
    return if products.size.zero?
    logger.info("We have found #{products.length} products")
    products.each do |product_hash|
      if !Product.exists?(productId: product_hash["productId"].to_s)
        a = product_hash["30daysCommission"]
        product_hash = product_hash.except("30daysCommission")
        product = Product.new(product_hash)
        product.salePrice = product_hash["salePrice"].slice(4..12)
        product.productTitle = ActionView::Base.full_sanitizer.sanitize(product_hash["productTitle"])
        product.originalPrice = product_hash["originalPrice"].slice(4..12)
        product.thirtydaysCommission = a
        product.is_approved = "n"
        product.category_id = category_id
        product.save!
      else
        # TODO: When product exists update it's attributes
        logger.info("Product Already Exists")
      end
    end
    logger.info("Products successfully saved!")
  end

  def self.clear_unwanted_products(products)
    products.update_all(is_approved: "y") unless products.nil?
    Product.all.limit(40).where.not(is_approved: "y").order("id desc").delete_all # Delete unselected products
  end

  # REVIEW: Consider deleting it and add subcategory argument to #new_product
  # method for mass saving products founded by crawler - works well for saving from file and iterating through the categories
  def self.save_hot_products(products, category_id, subcategory_id)
    fields = %w[productId productTitle productUrl imageUrl
                originalPrice salePrice discount evaluateScore
                commission commissionRate 30daysCommission volume
                packageType lotNum validTime storeName storeUrl]
    products.each do |i|
      if !Product.find_by(productId: i["productId"]).nil?
        logger.info("Product Already Exists")
      else
        details = AliexpressScraper.get_product_details(fields, i["productId"]) # gettig all details about product from hot product list
        if details["result"].nil?
          logger.info("We have not found any details about #{i['productTitle']}.")
        else
          details = details["result"]
          a = details["30daysCommission"]
          i = details.except("30daysCommission")
          promotion_link = AliexpressScraper.get_promotion_links(i["productUrl"])["result"]["promotionUrls"] # getting promotion url from aliexpress
          product = Product.new(i) # making new instance in Hot Products table
          product.salePrice = i["salePrice"].slice(4..12)
          product.originalPrice = i["originalPrice"].slice(4..12)
          product.promotionUrl = promotion_link[0]["promotionUrl"] # saving promotion url to record
          product.thirtydaysCommission = a # adding 30 days commission to record
          product.category_id = category_id
          product.subcategory_id = subcategory_id
          product.is_hot = "y"
          product.is_approved = "y"
          begin
            product.save
          rescue
            sleep 2
            ActiveRecord.connection.reconnect!
            retry
          end
        end
      end
    end
  end

  # Add product details
  def self.save_product_description(product_description, product_id)
    product = Product.find(product_id)
    product.update(productDescription: product_description)
  end

  def self.add_promotion_links(products)
    return if products.empty?
    promo_urls = AliexpressScraper.get_promotion_links(products.pluck(:productUrl))["result"]["promotionUrls"]
    i = 0
    products.each do |product|
      product.update(promotionUrl: promo_urls[i]["promotionUrl"])
      logger.info("Added to product #{product.id} promotion link: #{promo_urls[i]['promotionUrl']}")
      i += 1
    end
  end

  # Clear expired products
  def self.archive_expired_products
    Product.expired_products.update_all(archived: "y")
  end

  # HACK: Should sale price be equal to original price?
  def self.transform_price
    Product.where("salePrice like '%us%'").each do |product|
      product.salePrice = product.salePrice.slice(4..12)
      product.originalPrice = product.salePrice.slice(4.12)
      product.save
    end
  end

  # TODO
  def extract_product_brand
    #productTitle.split(" ")[0]
  end

end
