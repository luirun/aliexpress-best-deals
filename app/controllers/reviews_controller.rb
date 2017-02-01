class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :destroy]

  # GET /subsubcategories
  # GET /subsubcategories.json
  def index
    @reviews = Review.all.order("id desc")

    #META
    set_meta_tags title: "Product Reviews"
    set_meta_tags description: "What is worth to buy from china? We are testing everything for you!"
    set_meta_tags keywords: "aliexpress,reviews,review,product,shopping,shop"
  end

  # GET /subsubcategories/1
  # GET /subsubcategories/1.json
  def show
  	@promoted_reviews = Review.all.where.not(:id => @review.id)
  	@comment = Comment.new
  	@comments = Comment.where(:page => @review.id)

    #META
    set_meta_tags title: @review.title
    set_meta_tags description: @review.short_description
    set_meta_tags keywords: @review.keywords
  end

  # GET /subsubcategories/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.where(:title => params[:reviewTitle]).first
    if current_user != nil 
      
      if current_user.id == @review.author || current_user.is_admin == "y"
      else
        redirect_to root_path
        flash[:notice] = "You are not an author of this review and you can't edit it!"
      end

    else
      redirect_to root_path
       flash[:notice] = "Login to edit this review!"
    end

  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    @review.author = current_user.id
    product = Item.where(:productTitle => review_params[:productId]).first
    @review.productId = product.productId
    respond_to do |format|
      if @review.save
        format.html { redirect_to new_review_path, notice: 'Review was successfully created!' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    @review = Review.find(params[:id])
    product = Item.where(:productTitle => review_params[:productId]).first
    parameters = review_params
    parameters[:productId] = product.productId
    respond_to do |format|
      if @review.update(parameters)
        format.html { redirect_to reviews_path, notice: 'Review was successfully updated!' }
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
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search_items
    @items = Item.where("productTitle like '%#{params[:name]}%'").limit(5)
    respond_to do |format|
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.where(:title => pretty_url_decode(params[:reviewTitle])).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:title, :short_description, :long_description, :keywords, :promoted, :item_id, :cover, :author, :productId, :rating, :price)
    end
end
