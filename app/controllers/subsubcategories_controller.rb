class SubsubcategoriesController < ApplicationController
  before_action :set_subsubcategory, only: [:show, :edit, :update, :destroy]

  # GET /subsubcategories
  # GET /subsubcategories.json
  def index
    @subsubcategories = Subsubcategory.all
  end

  # GET /subsubcategories/1
  # GET /subsubcategories/1.json
  def show
  end

  # GET /subsubcategories/new
  def new
    @subsubcategory = Subsubcategory.new
  end

  # GET /subsubcategories/1/edit
  def edit
  end

  # POST /subsubcategories
  # POST /subsubcategories.json
  def create
    @subsubcategory = Subsubcategory.new(subsubcategory_params)

    respond_to do |format|
      if @subsubcategory.save
        format.html { redirect_to new_subsubcategory_path, notice: 'Subsubcategory was successfully created.' }
        format.json { render :show, status: :created, location: @subsubcategory }
      else
        format.html { render :new }
        format.json { render json: @subsubcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subsubcategories/1
  # PATCH/PUT /subsubcategories/1.json
  def update
    respond_to do |format|
      if @subsubcategory.update(subsubcategory_params)
        format.html { redirect_to @subsubcategory, notice: 'Subsubcategory was successfully updated.' }
        format.json { render :show, status: :ok, location: @subsubcategory }
      else
        format.html { render :edit }
        format.json { render json: @subsubcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subsubcategories/1
  # DELETE /subsubcategories/1.json
  def destroy
    @subsubcategory.destroy
    respond_to do |format|
      format.html { redirect_to subsubcategories_url, notice: 'Subsubcategory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subsubcategory
      @subsubcategory = Subsubcategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subsubcategory_params
      params.require(:subsubcategory).permit(:parent, :name)
    end
end
