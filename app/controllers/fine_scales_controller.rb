class FineScalesController < ApplicationController
  before_action :set_fine_scale, only: [:show, :edit, :update, :destroy]

  # GET /fine_scales
  # GET /fine_scales.json
  def index
    @fine_scales = FineScale.all
  end

  # GET /fine_scales/1
  # GET /fine_scales/1.json
  def show
  end

  # GET /fine_scales/new
  def new
    @fine_scale = FineScale.new
  end

  # GET /fine_scales/1/edit
  def edit
  end

  # POST /fine_scales
  # POST /fine_scales.json
  def create
    @fine_scale = FineScale.new(fine_scale_params)

    respond_to do |format|
      if @fine_scale.save
        format.html { redirect_to fine_scales_url, notice: 'Fine scale was successfully created.' }
        format.json { render :show, status: :created, location: @fine_scale }
      else
        format.html { render :new }
        format.json { render json: @fine_scale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fine_scales/1
  # PATCH/PUT /fine_scales/1.json
  def update
    respond_to do |format|
      if @fine_scale.update(fine_scale_params)
        format.html { redirect_to fine_scales_url, notice: 'Fine scale was successfully updated.' }
        format.json { render :show, status: :ok, location: @fine_scale }
      else
        format.html { render :edit }
        format.json { render json: @fine_scale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fine_scales/1
  # DELETE /fine_scales/1.json
  def destroy
    @fine_scale.destroy
    respond_to do |format|
      format.html { redirect_to fine_scales_url, notice: 'Fine scale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fine_scale
      @fine_scale = FineScale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fine_scale_params
      params.require(:fine_scale).permit(:old_condition_id, :new_condition_id, :percentage)
    end
end
