class TransportsController < ApplicationController
  before_action :set_transport, only: [:show, :edit, :update, :destroy, :add_members, :members]
  #skip_before_action :verify_authenticity_token

  # GET /transports
  # GET /transports.json
  def index
    authorize! :read, Transport
    type = params[:type]
    if type.present?
      @category = type == 'private' ? "Car Riders" : type == 'shuttle' ? "Shuttle Cars" : "???"
    end
    @transports = type ? Transport.where('lower(category) = ?', type.downcase) : Transport.all
     
    if params[:term] =~ /\A\d{10}\Z/    # 10 digits
      @transports = @transports.joins(:smart_cards).where(smart_cards: {code: params[:term]})
    elsif params[:term]
      @transports = @transports.where('name LIKE ?', "%#{params[:term]}%")
    end 
    if params[:period] == 'am'
      @transports = Transport.am_carpool
    elsif params[:period] == 'pm'
      @transports = Transport.pm_carpool
    end 

    @transports = @transports.order(:name).paginate(page: params[:page].blank? ? 1 : params[:page], per_page: 200) 
  end

  # GET /transports/1
  # GET /transports/1.json
  def show
    #authorize! :read, Transport
    @passengers = @transport.passengers
  end

  # GET /transports/new
  def new
    authorize! :manage, Transport
    @transport = Transport.new
  end

  # GET /transports/1/edit
  def edit
    authorize! :update, @transport
  end

  # POST /transports
  # POST /transports.json
  def create
    authorize! :manage, Transport
    @transport = Transport.new(transport_params)

    respond_to do |format|
      if @transport.save
        format.html { redirect_to @transport, notice: 'Transport was successfully created.' }
        format.json { render :show, status: :created, location: @transport }
      else
        format.html { render :new }
        format.json { render json: @transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transports/1
  # PATCH/PUT /transports/1.json
  def update
    authorize! :update, @transport
    respond_to do |format|
      if @transport.update(transport_params)
        format.html { 
          redirect_to transport_path(id:@transport.id, page:params[:page], type:params[:type]), notice: 'Transport was successfully updated.'
        }
        format.json { render :show, status: :ok, location: @transport }
      else
        format.html { render :edit }
        format.json { render json: @transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /transports/1/members
  def members
    authorize! :read, Transport
    @filterrific = initialize_filterrific(
      Student,
      params[:filterrific],
      select_options: {
        sorted_by: Student.options_for_sorted_by
      }
    ) or return

    @students = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end

    # Recover from invalid param sets, e.g., when a filter refers to the
    # database id of a record that doesn’t exist any more.
    # In this case we reset filterrific and discard all filter params.
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  # POST /transports/1/add_members
  def add_members
    authorize! :update, @transport
    params[:add].map {|id,on| Student.find(id)}.each do |student|
      grade_section = student.current_grade_section
      if @transport.passengers.create(student_id:student.id, name:student.name, family_no:student.family_no, grade_section:grade_section, class_name:grade_section.name) 
        next
      else
        redirect_to edit_transport_path(@transport), alert: 'Error: Students already added' and return
      end
    end
    redirect_to transport_path(@transport), notice: 'Students successfully added'
  end

  # DELETE /transports/1
  # DELETE /transports/1.json
  def destroy
    authorize! :destroy, @transport
    @transport.destroy
    respond_to do |format|
      format.html { redirect_to transports_url, notice: 'Transport was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transport
      @transport = Transport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transport_params
      params.require(:transport).permit(:category, :name, :status, :active, :notes, :contact_id, :contact_name, :contact_phone, :contact_email,
                    {smart_cards_attributes: [:id, :code, :detail, :ref, :_destroy]},
                    {passengers_attributes: [:id, :name, :student_id, :family_no, :grade_section_id, :class_name, :active, :_destroy]})
    end
end
