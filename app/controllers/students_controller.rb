class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    respond_to do |format|
      format.html {
        items_per_page = 20
        if params[:search]
          @students = Student.where('name LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: items_per_page)
        else
          @students = Student.paginate(page: params[:page], per_page: items_per_page)
        end
      }
      format.json {
        if params[:section]
          @students = Student.for_section(params[:section])
        end
      }
      format.csv {
        @students = Student.all
        render text: @students.to_csv
      }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.where(id: params[:id]).includes([:student_admission_info,:grade_sections_students]).first
    @current_grade = @student.grade_sections_students.where(academic_year_id:current_academic_year_id).try(:first).try(:grade_section)
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.where(id: params[:id]).includes([:student_admission_info]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :first_name, :last_name, :date_of_birth, :admission_no, :family_id, :gender, :blood_type, :nationality, :religion, :address_line1, :address_line2, :city, :state, :postal_code, :country, :mobile_phone, :home_phone, :email, :photo_uri, :status, :status_description, :is_active, :is_deleted, :student_no, :passport_no, :enrollment_date)
    end
end
