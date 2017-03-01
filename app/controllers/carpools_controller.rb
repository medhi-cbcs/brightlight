class CarpoolsController < ApplicationController
  before_action :set_carpool, only: [:show, :update, :destroy]
  before_action :check_format, except: [:index]

  layout 'sans_sidebar'

  # GET /carpools
  # GET /carpools.json
  def index
    authorize! :read, Carpool
    @carpool = Carpool.new
  end

  # GET /carpools/poll
  def poll
    authorize! :read, Carpool
    @carpools = Carpool.all.order(:updated_at)
    if params[:am]
      @carpools = @carpools.today_am
    elsif params[:pm]
      @carpools = @carpools.today_pm
    else
      @carpools = @carpools.today
    end
    if params[:since]
      @carpools = @carpools.since params[:since]
    else
      @carpools = @carpools.since Date.today.beginning_of_day.to_i
    end    
    @timestamp = @carpools.present? ? (@carpools.last.updated_at.to_f*1000).to_i : nil
    respond_to :json
  end

  # GET /carpools/1
  # GET /carpools/1.json
  def show 
    authorize! :read, Carpool 
    @expected_passengers = @carpool.late_passengers.active if params[:lpax]
  end

  # GET /carpools/new
  def new
    authorize! :create, Carpool
    @carpool = Carpool.new
  end

  # GET /carpools/1/edit
  def edit
    authorize! :update, Carpool
    @carpool = Carpool.includes(:passengers).find(params[:id])
    @carpool.passengers.each do |pax|
      @carpool.late_passengers.build transport:pax.transport, student:pax.student,
              grade_section:pax.grade_section, name:pax.name, class_name:pax.class_name,
              family_no:pax.family_no, family_id:pax.family_id, active:false
    end if @carpool.late_passengers.empty?
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /carpools
  # POST /carpools.json
  def create
    authorize! :update, Carpool
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
    authorize! :update, Carpool
    respond_to do |format|
      if @carpool.update(carpool_params) 
        format.html { redirect_to @carpool, notice: 'Carpool was successfully updated.' }
        format.json { render :show, status: :ok, location: @carpool }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @carpool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carpools/1
  # DELETE /carpools/1.json
  def destroy
    authorize! :destroy, Carpool
    @carpool.destroy
    respond_to do |format|
      format.html { redirect_to carpools_url, notice: 'Carpool was successfully destroyed.' }
      format.json { head :no_content }
    end
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

    def check_format
      redirect_to carpools_path unless params[:format] == 'json' || request.headers["Accept"] =~ /json/
    end

end
