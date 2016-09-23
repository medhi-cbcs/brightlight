class RawUnitsController < ApplicationController
  before_action :set_raw_unit, only: [:show, :edit, :update, :destroy]

  # GET /raw_units
  # GET /raw_units.json
  def index
    @raw_units = RawUnit.all
  end

  # GET /raw_units/1
  # GET /raw_units/1.json
  def show
  end

  # GET /raw_units/new
  def new
    @raw_unit = RawUnit.new
  end

  # GET /raw_units/1/edit
  def edit
  end

  # POST /raw_units
  # POST /raw_units.json
  def create
    @raw_unit = RawUnit.new(raw_unit_params)

    respond_to do |format|
      if @raw_unit.save
        format.html { redirect_to @raw_unit, notice: 'Raw unit was successfully created.' }
        format.json { render :show, status: :created, location: @raw_unit }
      else
        format.html { render :new }
        format.json { render json: @raw_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /raw_units/1
  # PATCH/PUT /raw_units/1.json
  def update
    respond_to do |format|
      if @raw_unit.update(raw_unit_params)
        format.html { redirect_to @raw_unit, notice: 'Raw unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @raw_unit }
      else
        format.html { render :edit }
        format.json { render json: @raw_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /raw_units/1
  # DELETE /raw_units/1.json
  def destroy
    @raw_unit.destroy
    respond_to do |format|
      format.html { redirect_to raw_units_url, notice: 'Raw unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raw_unit
      @raw_unit = RawUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raw_unit_params
      params.require(:raw_unit).permit(:name, :notes)
    end
end
