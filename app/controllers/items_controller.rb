class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :is_admin, only: [:save_hot_products, :auto_hot_products]


  # GET /items
  # GET /items.json
  def index
    @items = Item.limit(100)
    @categories = Category.all

    #META
    set_meta_tags title: "Find Cheapests Items"
    set_meta_tags description: "Are you looking for the cheapests aliexpress products? Here you can find products and also reviews of them!"
    set_meta_tags keywords: "aliexpress,category,products,deals,find,review,test"
  end

  # GET /items/1
  # GET /items/1.json
  def show
    if @item.productDescription == nil
      @item_details = AliCrawler.new.get_product_description(@item.productUrl) #[0] = Table of product details, [1] = product reviews, [1][:feedback] - review text, [1][:user_info] - user info in review
      @description_save = Item.save_product_description(@item_details[0], @item.id)
      @item = Item.find(@item.id)
    end

    if AliReview.where(:productId => @item.productId).first == nil #checking for existing reviews for product
      @reviews_save = AliReview.new.save_product_reviews(@item_details[1],@item.productId) #sending reviews with details and product id to AliReview model
    end

    @ali_reviews = AliReview.where(:productId => @item.productId, :is_empty => "n")
    @product_reviews = Review.all.order("RAND()")
    @recommended_items = Item.where(:category => @item.category).limit((@ali_reviews.length)*2)
    @best_items = Item.where(:is_hot => "y").limit(8) #limit%4=0!!

    #META
    set_meta_tags title: @item.productTitle
    set_meta_tags description: @item.productDescription
    set_meta_tags keywords: @item.productTitle.split.join(",")
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	def import
	  Item.import(params[:file])
	  redirect_to root_url, notice: "Items imported."
	end
  
	def get_subcategory
		@subcategories = Subcategory.where(:parent => params[:category_id]).all
	end

  def save_hot_products
    @items = AliCrawler.new.get_hot_products(params["currency"]["fields"], params[:category][:fields][1], params["language"]["fields"])
    save_items = Item.save_hot_products(@items["result"]["products"], params[:category][:fields][1])
  end

  def go_to_aliexpress
    @item = Item.where(:productId => params[:id]).first
    redirect_to @item.promotionUrl
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      text = "#{pretty_url_decode(params[:productTitle])}%"
      @item = Item.where("productTitle LIKE ?", text).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:totalResults, :productId, :productTitle, :productUrl, :imageUrl, :originalPrice, :salePrice, :discount, :evaluateScore, :thirtydaysCommission, :volume, :packageType, :lotNum, :validTime, :quanity_sold, :commision, :discount, :aff_url, :category, :subcategory, :sub_subcategory, :productDescription)
    end
end
