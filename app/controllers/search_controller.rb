# 1 - Search category with filters
# 2 - Search for products
#   2.1 - Search for product - GET params
#   2.2 - Search for product helper
# 3 - Search reviews by keywords
# 4 - Find all reviews written by selected author

class SearchController < ApplicationController
  # 1 - Search category with filters
  def search_category_redirect
    redirect_to search_category_products_path(params[:name], 1)
  end

  def search_category_with_filters
    @category = Category.where(name: params[:name]).first
    @subcategories = @category.subcategories.distinct
    subcategory = Subcategory.find_by(name: params[:subcategory]) unless params[:subcategory].nil?

    redirect_to search_category_path(params[:name], 1) && return if params[:p].nil?

    params[:min_price] = params[:min_price].to_f
    params[:max_price] = params[:max_price].to_f
    params[:max_price] = 9999.99 if params[:max_price] == 0.0

    redirect_to request.referer, flash: { alert: 'Prices must be greater than zero!' } && return if params[:min_price] < 0 || params[:max_price] < 0
    redirect_to request.referer, flash: { alert: 'Minimum price must be lower than maximum price!' } && return if params[:min_price] > params[:max_price]
    redirect_to request.referer, flash: { alert: 'Maxiumum price must be greaterthan 0.1$!' } && return if params[:max_price] < 0.1

    @products = if subcategory.nil?
                  @category.products.where(salePrice: params[:min_price]..params[:max_price]).limit(params[:p].to_i * 32)
                else
                  subcategory.products.where(salePrice: params[:min_price]..params[:max_price]).limit(params[:p].to_i * 32)
                end

    # META
    set_meta_tags title: "Search in #{params[:name]}"
    set_meta_tags description: "Find the best products from aliexpress in #{params[:name]} category"
    set_meta_tags keywords: 'aliexpress,category,products,deals'
  end

  #------------------------------------------------ 1 - END -------------------------------------

  # 2 - Search for product

  # 2.1 - Search product by params in url - if nothing found then go to 2.2, if it fails we flash "nothing found"
  def search_product
    params[:name] = request.GET[:name] unless request.GET[:name].nil? # if there is no name param use old name
    redirect_to search_product_path(params[:name], 1) if params[:p].nil?
    params[:name] = params[:name].split # we are splitting our keyword into separate words
    if params[:name].length > 1 # whene someone is looking for many words
      search = '%'
      params[:name].each do |param|
        search += "#{param}%"
      end
      @products = Product.where("productTitle like '%#{search}'")
      if @products[0].nil? # shorten phrase if nothing found
        params[:name] = params[:name].slice(0..params[:name].length - 2)
        @products = search_loop(params[:name])
        # if we found nothing after shortening we say that nothing is found
        flash[:error] = 'Sorry, we found nothing ;(' if @products[0].nil?
      end
    else # when someone is looking for only one word
      @products = Product.where("productTitle like '%#{params[:name][0]}%'")
    end
  end

  # 2.2 - Search product helper - If 2.1 not found any product then we go here and try to find similar product
  # used to general searching if nothing found earlier
  # there was argument search_phrase for this function earlier - check this if you can
  def search_loop
    search = '%'
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
