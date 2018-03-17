=begin
  ------------------------------ Navigation -----------------------------
    1 - Search category with filters
    2 - Search for products
      2.1 - Search for product - GET params
      2.2 - Search for product helper

    3 - Search reviews by keywords
    4 - Find all reviews written by selected author

  ---------------------------------- End ------------------------------------

=end


class SearchController < ApplicationController
  # 1- Search category with filters
  def search_category_redirect
    redirect_to search_category_products_path(params[:name], 1)
  end

  def search_category_with_filters
    @category = Category.where(name: params[:name]).first
    @subcategories = @category.subcategories.distinct
    @subcategory = Subcategory.find_by(name: params[:subcategory]) if !params[:subcategory].nil?
    # checking that pagination exsists, if not redirecting to 1 page
    redirect_to search_category_path(params[:name], 1) if params[:p].nil?
    
    params[:price_min] = params[:price_min].to_f
    params[:price_max] = params[:price_max].to_f
    params[:price_max] = 9999.99 if params[:price_max] == 0.0

    if params[:price_min] != 0.0
      if params[:price_min] < params[:price_max]
        min_price = params[:price_min]
      else
        flash[:notice] = "Minimal price can't be higher than maximum price!"
        min_price = 9999
        redirect_to request.referer
      end
    else
      min_price = 0.0
    end

    if params[:price_max] != 9999.99
      if params[:price_max] > params[:price_min]
        max_price = params[:price_max]
      else
        flash[:notice] = "Minimal price can't be higher than maximum price!"
        max_price = 1
        redirect_to request.referer
      end
    else
      max_price = 9999.99
    end

    if min_price < 0 || max_price <= 0
      flash[:notice] = "You can't search for products cheaper than 0.01$!"
      redirect_to request.referer
    elsif @subcategory.nil?
      @products = @category.products.where(salePrice: min_price..max_price)
    else
      @products = @subcategory.products.where(salePrice: min_price..max_price)
    end

    # when user search for subcategory - we are setting subcategory_id variable
    unless params[:subcategory].nil?
      subcategory_id = @subcategories.where(name: params[:subcategory]).first.id
      @products = @products.where(subcategory_id: subcategory_id)
    end

    # META
    set_meta_tags title: "Search in #{params[:name]}"
    set_meta_tags description: "Find the best products from aliexpress in #{params[:name]} category"
    set_meta_tags keywords: "aliexpress,category,products,deals"
  end

  #------------------------------------------------ 1 - END -------------------------------------

  # 2 - Search for product

  # 2.1 - Search product by params in url - if nothing found then go to 2.2, if it fails we flash "nothing found"
  def search_product
    params[:name] = request.GET[:name] unless request.GET[:name].nil? # if there is no name param use old name
    redirect_to search_product_path(params[:name], 1) if params[:p].nil?
    params[:name] = params[:name].split # we are splitting our keyword into separate words
    if params[:name].length > 1 # whene someone is looking for many words
      search = "%"
      params[:name].each do |param|
        search += "#{param}%"
      end
      @products = Product.where("productTitle like '%#{search}'")
      if @products[0].nil? # shorten phrase if nothing found
        params[:name] = params[:name].slice(0..params[:name].length - 2)
        @products = search_loop(params[:name])
        # if we found nothing after shortening we say that nothing is found
        flash[:error] = "Sorry, we found nothing ;(" if @products[0].nil?
      end
    else # when someone is looking for only one word
      @products = Product.where("productTitle like '%#{params[:name][0]}%'")
    end
  end

  # 2.2 - Search product helper - If 2.1 not found any product then we go here and try to find similar product
  # used to general searching if nothing found earlier
  # there was argument search_phrase for this function earlier - check this if you can
  def search_loop
    search = "%"
    params[:name].each do |param|
      search += "#{param}%"
    end
    @products = Product.where("productTitle like '%#{search}'")
  end

  # ---------------------------------- 2 - END -------------------------------

  # 3 - Search reviews by keyword

  def search_keyword
    @reviews = Review.where("keywords like '%#{params[:keyword]}%'")
  end

  #----------------------------------- 3 - END ---------------------------------

  # 4 - Find all reviews written by selected author

  def search_author
    @reviews = User.find_by(nickname: params[:author]).reviews
  end

  #---------------------------------- 4 - END --------------------------------
end
