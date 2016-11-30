class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
      @category = Category.where(:name => params[:name]).first

      #checking that pagination exsists, if not redirecting to 1 page
      if params[:p] == nil
        redirect_to search_in_category_path(params[:name], 1)
      end

      #price_min, price_max - 0 ? LOGIC
      if params[:price_min] == nil || params[:price_min] == "" #0 ? LOGIC
        if params[:price_max] != nil # 0 1 LOGIC
          if params[:price_max] != "" #price max not contain empty space
            if params[:price_max].to_f <= 0
              flash[:notice] = "Price max must be higher than zero!"
              redirect_to search_in_category_path(params[:name], params[:p])
            else # 0 1 LOGIC
              @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: 0..params[:price_max].to_f)
            end
          else #when price max contains only space
            @items = Item.where(:category => @category.id, :is_approved => "y")
          end
        else # 0 0 LOGIC
          @items = Item.where(:category => @category.id, :is_approved => "y")
        end
      else
        if params[:price_min].to_f < 0
          flash[:notice] = "Price min must be higher than zero!"
          redirect_to search_in_category_path(params[:name], params[:p])
        else #PRICE MIN > 0
          puts params[:price_max]
          if params[:price_max] != "" # PRICE MAX != EMPTY
            if params[:price_min] > params[:price_max] # min higher than max
              flash[:notice] = "Maximum price must be higher than minimal price!"
              redirect_to search_in_category_path(params[:name], params[:p])
            else # 1 - 1 LOGIC
              @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: params[:price_min].to_f..params[:price_max].to_f)
            end
          else # 1 0 LOGIC
            @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: params[:price_min].to_f..99999999)
          end
        end
      end

    #META
    set_meta_tags title: "Search in #{params[:name]}"
    set_meta_tags description: "Find the best items from aliexpress in #{params[:name]} category"
    set_meta_tags keywords: "aliexpress,category,products,deals"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end
end
