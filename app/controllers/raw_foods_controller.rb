class RawFoodsController < ApplicationController
  before_action :set_raw_food, only: [:show, :edit, :update, :destroy]

  # GET /raw_foods
  # GET /raw_foods.json
  def index
     respond_to do |format|
      format.html {
        items_per_page = 20
        if params[:search]
          @raw_foods = RawFood.where('UPPER(name) LIKE ?', "%#{params[:search].upcase}%").order(:name).paginate(page: params[:page], per_page: items_per_page)
        else
          @raw_foods = RawFood.order(:name).paginate(page: params[:page], per_page: items_per_page)
        end
      }
      format.csv {
        @raw_foods = RawFood.all
        render text: @raw_foods.to_csv
      }
    end
  end

  # GET /raw_foods/1
  # GET /raw_foods/1.json
  def show
  end

  # GET /raw_foods/new
  def new
    @raw_food = RawFood.new
  end

  # GET /raw_foods/1/edit
  def edit
  end

  # POST /raw_foods
  # POST /raw_foods.json
  def create
    @raw_food = RawFood.new(raw_food_params)

    respond_to do |format|
      if @raw_food.save
        format.html { redirect_to @raw_food, notice: 'Raw food was successfully created.' }
        format.json { render :show, status: :created, location: @raw_food }
      else
        format.html { render :new }
        format.json { render json: @raw_food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /raw_foods/1
  # PATCH/PUT /raw_foods/1.json
  def update
    respond_to do |format|
      if @raw_food.update(raw_food_params)
        format.html { redirect_to @raw_food, notice: 'Raw food was successfully updated.' }
        format.json { render :show, status: :ok, location: @raw_food }
      else
        format.html { render :edit }
        format.json { render json: @raw_food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /raw_foods/1
  # DELETE /raw_foods/1.json
  def destroy
    @raw_food.destroy
    respond_to do |format|
      format.html { redirect_to raw_foods_url, notice: 'Raw food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raw_food
      @raw_food = RawFood.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raw_food_params
      params.require(:raw_food).permit(:name, :brand, :kind, :min_stock, :raw_unit_id)
    end
end
