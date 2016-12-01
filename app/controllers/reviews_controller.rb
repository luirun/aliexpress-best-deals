class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /subsubcategories
  # GET /subsubcategories.json
  def index
    @reviews = Review.all

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
    @popular_reviews = Review.all.limit(4)
    @popular_items = Item.where(:is_hot => "y").limit(4)

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
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to new_review_path, notice: 'Subsubcategory was successfully created.' }
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
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Subsubcategory was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.where(:title => params[:reviewTitle]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:title, :short_description, :long_description, :keywords, :promoted, :item_id, :cover, :author)
    end
end
