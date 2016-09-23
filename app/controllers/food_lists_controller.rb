class FoodListsController < ApplicationController
  before_action :set_food_list, only: [:show, :edit, :update, :destroy]

  # GET /food_lists
  # GET /food_lists.json
  def index
    @food_lists = FoodList.all
  end

  # GET /food_lists/1
  # GET /food_lists/1.json
  def show
  end

  # GET /food_lists/new
  def new
    @food_list = FoodList.new
  end

  # GET /food_lists/1/edit
  def edit
  end

  # POST /food_lists
  # POST /food_lists.json
  def create
    @food_list = FoodList.new(food_list_params)

    respond_to do |format|
      if @food_list.save
        format.html { redirect_to @food_list, notice: 'Food list was successfully created.' }
        format.json { render :show, status: :created, location: @food_list }
      else
        format.html { render :new }
        format.json { render json: @food_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /food_lists/1
  # PATCH/PUT /food_lists/1.json
  def update
    respond_to do |format|
      if @food_list.update(food_list_params)
        format.html { redirect_to @food_list, notice: 'Food list was successfully updated.' }
        format.json { render :show, status: :ok, location: @food_list }
      else
        format.html { render :edit }
        format.json { render json: @food_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_lists/1
  # DELETE /food_lists/1.json
  def destroy
    @food_list.destroy
    respond_to do |format|
      format.html { redirect_to food_lists_url, notice: 'Food list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food_list
      @food_list = FoodList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_list_params
      params.require(:food_list).permit(:name, :notes, :picture_url)
    end
end
