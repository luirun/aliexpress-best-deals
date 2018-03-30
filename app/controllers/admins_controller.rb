=begin
  --------------------- NAVIGATION -------------------------
  1 - searching for products - LINE 1
  2 - serching for hot products by category - LINE 35
  3 - search for all hot products/all not hot products in subcategories
  4 - various cleaning
  5 - admin comment manager
  6 - fill category from file
  7 - fetch product details
  ----------------------- END ---------------------------------
=end

class AdminsController < ApplicationController
  before_action :is_admin

  # 1 - search for products
  # search_products -> list_products -> save_products
  # admin/form -> admin/product_list [POST] -> admin/saved_products [POST]
  # 3 methods below are connected with themselves
  def search_for_products; end

  def list_found_products
    @products = AliexpressScraper.search_url_generator(params)
    category_id = params[:category][:fields][1]
    Product.ali_new(@products["result"]["products"], category_id)
  end

  def save_found_products
    Product.clear_unwanted_products(params[:productId]) # delete products that were not checked in form earlier
    product_urls = Product.where(promotionUrl: nil).select(:productUrl, :id).limit(40).order("id desc")
    return if product_urls[0].nil?
    promotion_urls = AliCrawler.new.get_promotion_links(product_urls)
    Product.add_promotion_links(promotion_urls["result"]["promotionUrls"], product_urls)
  end

  #---------------------------- 1 end -----------------------------------

  # 2 - search hot products(high quality products) by category
  # /hot_products_by_category [FORM HERE] -> /hot_products_by_category [POST]
  def save_hot_products_by_category
    Subcategory.fill_all_subcategories_of_category(params[:category][:fields][1])
  end

  #---------------------------- 2 end -----------------------------------

  # 3 - search for all hot products
  # /auto_save_hot_products -> /auto_save_hot_products [POST]
  # this action will take 15-20min to be done, be sure you are able to start it now!
  def auto_hot_products
    return unless request.post?
    @subcategories = Subcategory.all
    @subcategories.each do |subcategory|
      @products = AliCrawler.new.get_hot_products("USD", subcategory.id, "EN")
      Product.save_hot_products(@products["result"]["products"], subcategory.parent, subcategory.id)
    end
  end

  # /mass_subcategory_filling
  def mass_subcategory_filling
    @subcategories = Subcategory.all
    @subcategories.each do |subcategory|
      @products = AliexpressScraper.search_for_category_products("", subcategory.id)
      Product.save_hot_products(@products["result"]["products"], subcategory.parent, subcategory.id)
    end
    redirect_to admins_path
  end

  #---------------------------- 3 end -----------------------------------

  # 4 - various clearing
  # /clear_expired_products => here => Product.clear_expired_products
  def clear_expired_products
    Product.clear_expired_products
  end

  # /delete_empty_reviews
  def delete_empty_reviews
    empty_reviews = AliReview.where(is_empty: "y").where("length(review_content) < ?", 5)
    AliReview.new.delete_empty_reviews(empty_reviews)
    # unexisting_product_reviews = AliReview.select(:productId).distinct
    # unexisting_product_reviews.each do |review|
    # if Product.where(:productId => review.productId).first == nil
    # AliReview.new.delete_empty_reviews(AliReview.where(:productId => review.productId))
    # end
    # end
  end
  #---------------------------- 4 end -----------------------------------

  # 5 - comment manager
  # /comments_manager [FORM] -> /comments_manager_update [POST]
  def comments_manager
    @unapproved_comments = Comment.all.where(accepted: "n").order("id desc")
  end

  def comments_manager_update
    Comment.approve_comments(params[:commentId])
    Comment.delete_comments(params[:commentId])
    redirect_to admins_path
  end

  #---------------------------- 5 end -----------------------------------

  # 6 - fill category from file
  # fill_category_from_file [FORM] -> /save_from_file [POST]
  def save_from_file
    keywords = params[:keywords]["fields"].read.split(",")
    category = params[:category][:fields][1]
    Product.save_from_file(keywords, category)
    redirect_to admins_path
  end

  #---------------------------- 6 end -----------------------------------

  # 7 - fetch product details
  def update_products_details
    proxies = ["#addproxyhere comma sepparated"]
    begin
      proxy = proxies[rand(0..proxies.length)]
      products = Product.select(:id, :productId, :productUrl).where(with_reviews: nil).order("RAND()")
      browser = Watir::Browser.new :chrome, switches: ["--proxy-server=#{proxy}"]
      browser.goto "https://aliexpress.com"
      browser.element(class: "close-layer").click
      i = 0
      products.each do |product|
        browser.goto product.productUrl
        # return [0] = Table of product details, [1] = product reviews,
        # [1][:feedback] - review text, [1][:user_info] - user info in review
        product_details = Product.fetch_extra_data(browser)
        if product_details == "end"
          product.delete
        else
          @description_save = Product.save_product_description(product_details[0], product.id)
          @reviews_save = AliReview.new.save_product_reviews(product_details[1], product.productId)
        end
        sleep(rand(7..15))
        i += 1
        sleep(rand(15..60)) if (i % 10).zero?
      end
      browser.close
    rescue
      browser.close
      retry
    end
  end
  #---------------------------- 7 end -----------------------------------

  # one time script to mark products with reviews or not
  def mark_products_with_reviews
    products = Product.all
    products.each do |product|
      product.with_reviews = "y" unless AliReview.where(productId: product.productId)[0].nil?
      product.save if product.with_reviews == "Y"
    end
  end

  # undone yet
  def article_manager
    @articles = Review.all
  end
end
