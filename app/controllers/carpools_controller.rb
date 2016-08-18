class CarpoolsController < ApplicationController
  before_action :set_carpool, only: [:show, :edit, :update, :destroy]

  # GET /carpools
  # GET /carpools.json
  def index
    if params[:since]
      since = CGI.unescape params[:since]
      since_time = DateTime.parse since
      @carpools = Carpool.where('updated_at > ?', since_time).order(:updated_at)
    else
      @carpools = Carpool.where('created_at > ?', Date.today).order(:updated_at)
    end
  end

  # GET /carpools/1
  # GET /carpools/1.json
  def show
  end

  # GET /carpools/new
  def new
    @carpool = Carpool.new
  end

  # GET /carpools/1/edit
  def edit
  end

  # POST /carpools
  # POST /carpools.json
  def create
    @carpool = Carpool.new(carpool_params)

    respond_to do |format|
      if @carpool.save
        format.html { redirect_to @carpool, notice: 'Carpool was successfully created.' }
        format.json { render :show, status: :created, location: @carpool }
      else
        format.html { render :new }
        format.json { render json: @carpool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carpools/1
  # PATCH/PUT /carpools/1.json
  def update
    respond_to do |format|
      if @carpool.update(carpool_params)
        format.html { redirect_to @carpool, notice: 'Carpool was successfully updated.' }
        format.json { render :show, status: :ok, location: @carpool }
      else
        format.html { render :edit }
        format.json { render json: @carpool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carpools/1
  # DELETE /carpools/1.json
  def destroy
    @carpool.destroy
    respond_to do |format|
      format.html { redirect_to carpools_url, notice: 'Carpool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carpool
      @carpool = Carpool.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carpool_params
      params.require(:carpool).permit(:category, :transport_id, :barcode, :transport_name, :period, :sort_order, :active, :status, :arrival, :departure, :notes)
    end
end
