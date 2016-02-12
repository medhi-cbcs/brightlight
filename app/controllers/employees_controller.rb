class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index
    respond_to do |format|
      format.html {
        items_per_page = 20
        if params[:search]
          @employees = Employee.where('name LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: items_per_page)
        else
          @employees = Employee.paginate(page: params[:page], per_page: items_per_page)
        end
      }
      format.csv { 
        @employees = Employee.all
        render text: @employees.to_csv 
      }
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:name, :first_name, :last_name, :gender, :date_of_birth, :place_of_birth, :joining_date, :job_title, :employee_number, :marital_status, :experience_year, :experience_month, :employment_status, :children_count, :home_address_line1, :home_address_line2, :home_city, :home_state, :home_country, :home_postal_code, :mobile_phone, :home_phone, :office_phone, :other_phone, :emergency_contact_number, :emergency_contact_name, :email, :photo_uri, :education_degree, :education_graduation_date, :education_school, :education_degree2, :education_graduation_date2, :education_school2, :supervisor_id, :department_id, :nationality, :blood_type)
    end
end
