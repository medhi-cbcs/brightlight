class TransportsController < ApplicationController
  before_action :set_transport, only: [:show, :edit, :update, :destroy, :add_members, :members]

  # GET /transports
  # GET /transports.json
  def index
    type = params[:type]
    if type.present?
      @category = type == 'private' ? "Car Riders" : type == 'shuttle' ? "Shuttle Cars" : "???"
    end
    @transports = type ? Transport.where('lower(category) = ?', type.downcase) : Transport.all
  end

  # GET /transports/1
  # GET /transports/1.json
  def show
    @passengers = @transport.passengers
  end

  # GET /transports/new
  def new
    @transport = Transport.new
  end

  # GET /transports/1/edit
  def edit
  end

  # POST /transports
  # POST /transports.json
  def create
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
    respond_to do |format|
      if @transport.update(transport_params)
        format.html { 
          if params[:add_members]
            redirect_to members_transport_path(@transport)
          else
            redirect_to @transport, notice: 'Transport was successfully updated.'
          end 
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
      params.require(:transport).permit(:category, :name, :status, :active, :notes, :contact_id, :contact_name, :contact_phone, :contact_email)
    end
end