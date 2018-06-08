class AdminsController < ApplicationController
  before_action :is_admin?

  # search_for_products -> list_found_products -> save_approved_products
  def search_for_products
    @categories = Category.select(:id, :name).all
  end

  def list_found_products
    @products = AliexpressScraper.search_for_category_products(params[:keyword], params[:category][:fields][1], params)
    Product.new_product(@products["result"]["products"], params[:category][:fields][1])
  end

  def save_approved_products
    products = Product.where('productId in (?)', params[:productId])
    Product.clear_unwanted_products(products) # Delete products that were not checked in form earlier
    return if products.empty?
    Product.add_promotion_links(products)
    redirect_to admins_path
  end

  # Search for hot products(high quality products) by category
  def save_hot_products_by_category
    Subcategory.fill_all_subcategories_of_category(params[:category][:fields][1])
  end

  def fill_all_subcategories
    Subcategory.all.each do |subcategory|
      products = AliexpressScraper.search_for_category_products("", subcategory.id)
      Product.save_hot_products(@products["result"]["products"], subcategory.category_id, subcategory.id)
    end
    redirect_to admins_path
  end

  def archive_expired_products
    Product.archive_expired_products
  end

  def delete_empty_reviews
    AliReview.delete_empty_reviews.delete_all
    if request.post? # TODO: It's not implemented by UI now. Refactor it later.
      AliReview.pluck(:productId).uniq.each do |review|
        if Product.where(:productId => review.productId).first == nil
          AliReview.new.delete_empty_reviews(AliReview.where(:productId => review.productId))
        end
      end
    end
  end

  def comments_manager
    @unapproved_comments = Comment.all.where(accepted: "n").order("id desc")
    if request.post?
      Comment.approve_comments(params[:commentId])
      Comment.delete_comments(params[:commentId])
      redirect_to admins_path
    end
  end

  def fill_category_from_file
    if request.post?
      keywords = params[:keywords]["fields"].read.split(",")
      category = params[:category][:fields][1]
      Category.fill_from_file(keywords, category)
      redirect_to admins_path
    end
  end

  # HACK: Method duplicated from AliexpressScraper - delete if not needed
  def update_products_details; end

  # put .html of this page in public dir - https://www.aliexpress.com/all-wholesale-products.html
  def fetch_categories
    page = File.open("#{Rails.root}/public/Categories.html") { |f| Nokogiri::HTML(f) }
    Category.save_fetched_categories_and_subcategories(page)
  end
  #---------------------------- 7 end -----------------------------------

  # one time script to mark products with reviews or not
  def mark_products_with_reviews
    Product.all.each do |product|
      product.with_reviews = "y" unless AliReview.where(productId: product.productId)[0].nil?
      product.save if product.with_reviews == "Y"
    end
  end

  # TODO
  def article_manager
    @articles = Review.all
  end
end
