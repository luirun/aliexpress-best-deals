# --------------------------------- NAVIGATION ------------------------------
# 1 - Basic CRUD actions
# 2 - Various Actions
# ------------------------------------ END ---------------------------------

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :destroy, :product_like, :product_unlike]
  before_action :is_admin, only: [:create]

  # 1 - Basic CRUD Actions

  def index
    @categories = Category.all
    @categories ||= ["Sorry, actually no categories ;("]

    # META
    set_meta_tags title: "Find Cheapests Products"
    set_meta_tags description: "Are you looking for the cheapests aliexpress products? Here you can find products and also reviews of them!"
    set_meta_tags keywords: "aliexpress,category,products,deals,find,review,test"
  end

  def show
    @ali_reviews = AliReview.non_empty_reviews_of_product(@product)
    @product_reviews = Review.all_by_random
    @recommended_products = Product.recommended_products(@product.category_id)
    @best_products = Product.hot_products.limit(8) # limit must be %4=0!!
    @branded_products = Product.all_from_brand(@product) # limit%4==0
    @subcategory = Subcategory.find(@product.subcategory_id) if !@product.subcategory_id.nil? && @product.subcategory_id != @product.category_id

    # META
    set_meta_tags title: @product.productTitle.html_safe
    set_meta_tags description: @product.productDescription
    set_meta_tags keywords: @product.productTitle.split.join(",")
    set_meta_tags og: {
      image: @product.imageUrl
    }
    set_meta_tags twitter: {
      image: @product.imageUrl,
      title: @product.productTitle,
      description: "Only #{@product.salePrice}$ for this new product - check this out!"
    }
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # ---------------------------------- 1 - END --------------------------------

  # 2 - Various Actions

  # like box on product page, appears only on resolution >= 1080p
  def product_like
    if user_signed_in?
      ProductLike.create_like(@product.productId, current_user_columns.id, cookies[:user_id])
    else
      ProductLike.create_like(@product.productId, 4, cookies[:user_id])
    end
    render layout: false
  end

  def product_unlike
    ProductLike.destroy_like(@product.productId, cookies[:user_id])
    render layout: false
  end

  def import
    Product.import(params[:file])
    redirect_to root_url, notice: "Poducts imported."
  end

  def find_subcategory
    @subcategories = Subcategory.find_all_products_of_parent
  end

  def go_to_aliexpress
    @product = Product.where(productId: params[:id]).first
    redirect_to @product.promotionUrl
  end

  # -------------------------------- 2 - END ------------------------------

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.like_title(pretty_url_decode(params[:productTitle]))
    redirect_to error_path("product-not-found") if @product.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params
      .require(:product)
      .permit(
        :totalResults, :productId, :productTitle, :productUrl,
        :imageUrl, :originalPrice, :salePrice, :discount,
        :evaluateScore, :thirtydaysCommission, :volume, :packageType,
        :lotNum, :validTime, :quanity_sold, :commision, :discount,
        :aff_url, :category, :subcategory, :sub_subcategory, :productDescription
      )
  end
end

# actually not used
def similar_product
  @product = Product.find_product(params[:productId])
  if @product.nil?
    fields = AliConfig.new.alibaba_api_fields[:list]
    category_id = Category.where(name: params[:category]).first.id
    @product = AliCrawler.new.get_product_details(fields, params[:productId])
    @product = Product.ali_new(@product["result"], category_id)
    @product = Product.where(productId: params[:productId]).first
  end
  redirect_to product_path(pretty_url_encode(@product.productTitle))
end

# PATCH/PUT /products/product title
def update
  respond_to do |format|
    if @product.update(product_params)
      format.html { redirect_to @product, notice: "Product was successfully updated." }
      format.json { render :show, status: :ok, location: @product }
    else
      format.html { render :edit }
      format.json { render json: @product.errors, status: :unprocessable_entity }
    end
  end
end
