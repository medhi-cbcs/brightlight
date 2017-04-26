class Api::CarpoolsController < Api::BaseController
  before_action :set_carpool, only: [:show, :update, :destroy]

  @@reorder = 0

  # GET /carpools
  # GET /carpools.json
  def index
    @carpool = Carpool.new
  end

  # GET /carpools/poll
  def poll
    @carpools = Carpool.all.order(:sort_order,:updated_at)
    if params[:am]
      @carpools = @carpools.today_am
    elsif params[:pm]
      @carpools = @carpools.today_pm
    else
      @carpools = @carpools.today
    end

    @timestamp = @carpools.present? ? (@carpools.last.updated_at.to_f*1000).to_i : nil
    @reorder = @@reorder
    
    if params[:since]      
      @carpools = @carpools.since params[:since] unless params[:since].to_i < @reorder
    end    
    respond_to :json
  end

  # GET /carpools/1
  # GET /carpools/1.json
  def show 
    if @carpool
      @expected_passengers = @carpool.late_passengers.active if params[:lpax]
    else
      puts "Error: NOT FOUND #{params[:id]}"
      render json: @carpool.errors, status: :unprocessable_entity
    end 
  end

  # POST /carpools.json
  def create
    @carpool = Carpool.new(carpool_params)
    
    if @carpool.save
      render json: @carpool, status: :created, location: @carpool
    else
      render json: @carpool.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /carpools/1.json
  def update
    if @carpool.update(carpool_params)         
      render json: @carpool, status: :ok, location: @carpool
    else
      render json: @carpool.errors, status: :unprocessable_entity
    end
  end

  # DELETE /carpools/1.json
  def destroy
    @carpool.destroy
    head :no_content
  end

  def reorder
    @carpools = Carpool.update(params[:carpools].keys, params[:carpools].values)
    @@reorder = (Time.now.to_f*1000).to_i
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carpool
      if Time.now < Date.today.noon
        @carpool = Carpool.today_am.find_uid(params[:id])
      else
        @carpool = Carpool.today_pm.find_uid(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carpool_params
      params.require(:carpool).permit(:category, :transport_id, :barcode, :transport_name, :period, :sort_order,
                                      :active, :status, :arrival, :departure, :notes,
                                      late_passengers_attributes: [:id, :name, :student_id, :transport_id, :family_no,
                                        :family_id, :active, :grade_section_id, :class_name])
    end

end
