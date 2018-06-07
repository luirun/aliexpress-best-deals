class ReviewsController < ApplicationController
  before_action :set_review, except: [:index, :new, :create]

  # GET /subsubcategories
  # GET /subsubcategories.json
  def index
    @reviews = Review.all.order("id desc")

    # META
    set_meta_tags title: "Product Reviews"
    set_meta_tags description: "What is worth to buy from china? We are testing everything for you!"
    set_meta_tags keywords: "aliexpress,reviews,review,product,shopping,shop"
  end

  def show
    @promoted_reviews = Review.all.where.not(id: @review.id)
    @product = Product.find_by(productId: @review.product_id)
    @similar_products = Product.where(category_id: @product.category_id).limit(10).sample(5)
    @popular_reviews = Review.where.not(id: @review).limit(5)
    @comments = Comment.where(page: @review.id)

    set_meta_tags title: @review.title
    set_meta_tags description: @review.short_description
    set_meta_tags keywords: @review.keywords
    set_meta_tags og: {image: @review.cover}
    set_meta_tags twitter: {image: @review.cover, title: @review.title, description: @review.short_description}
  end

  def new
    @review = Review.new
  end

  def edit
    @review = Review.where(title: params[:reviewTitle]).first
    if !current_user.nil?
      unless current_user.id == @review.author || current_user.is_admin == "y"
        redirect_to root_path
        flash[:notice] = "You are not an author of this review and you can't edit it!"
      end
    else
      redirect_to root_path, notice: "Login to edit this review!"
    end
  end

  def create
    @review = Review.new(review_params)
    @review.author = current_user.id
    product = Product.where(product_title: review_params[:productId]).first
    @review.productId = product.productId
    respond_to do |format|
      if @review.save
        format.html { redirect_to new_review_path, notice: "Review was successfully created!" }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # REVIEW: Is it work?
  def update
    product = Product.where(productTitle: review_params[:productId]).first
    parameters[:productId] = product.productId
    respond_to do |format|
      if @review.update(parameters)
        format.html { redirect_to reviews_path, notice: "Review was successfully updated!" }
        format.json { render :show, status: :ok, location: @review.title }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search_products
    @products = Product.where("productTitle like '%#{params[:name]}%'").limit(5)
    respond_to do |format|
      format.js   { render layout: false }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    title = pretty_url_decode(params[:reviewTitle])
    @review = Review.find_by_title(title)
    return unless @review.nil?

    title = title.split(" ")
    if title.length > 2
      @review = Review.where("title LIKE ?", "%#{title[1]}%#{title[2]}%").first
    else
      flash[:alert] = "Review not found!"
      redirect_to reviews_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def review_params
    params.require(:review).permit(
      :title, :short_description, :long_description,
      :keywords, :promoted, :product_id, :cover,
      :author, :productId, :rating, :price
    )
  end
end
