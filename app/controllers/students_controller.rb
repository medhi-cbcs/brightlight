class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    respond_to do |format|
      format.html {
        items_per_page = 20
        if params[:search]
          @students = Student.where('UPPER(name) LIKE ?', "%#{params[:search].upcase}%").paginate(page: params[:page], per_page: items_per_page)
        else
          @students = Student.paginate(page: params[:page], per_page: items_per_page)
        end
      }
      format.json {
        if params[:section].present?
          @students = Student.for_section(params[:section])
                        .select('students.id,students.name,grade_sections_students.grade_section_id,grade_sections_students.order_no')
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
    @current_grade = @student.current_grade_section
  end

  # GET /students/new
  def new
    authorize! :manage, Student
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    authorize! :edit, Student
  end

  # POST /students
  # POST /students.json
  def create
    authorize! :manage, Student
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
    authorize! :edit, Student
    respond_to do |format|
      if @student.update(student_params)
        format.html {
          if student_params[:student_books_attributes].present?
            redirect_to student_student_books_path(@student), notice: 'Student book was successfully created.'
          else
            redirect_to @student, notice: 'Student was successfully created.'
          end
        }
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
    authorize! :destroy, Student
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
      params.require(:student).permit(:name, :first_name, :last_name, :date_of_birth, :admission_no, :family_id, :gender,
        :blood_type, :nationality, :religion, :address_line1, :address_line2, :city, :state, :postal_code, :country,
        :mobile_phone, :home_phone, :email, :photo_uri, :status, :status_description, :is_active, :is_deleted, :student_no,
        :passport_no, :enrollment_date,
        {student_books_attributes: [:id, :student_id, :book_copy_id, :academic_year_id, :course_text_id, :copy_no, :grade_section_id,
            :grade_level_id, :course_id, :issue_date, :return_date, :initial_copy_condition_id, :end_copy_condition_id, :created_at,
            :updated_at, :barcode, :student_no, :roster_no, :grade_section_code, :grade_subject_code, :notes, :prev_academic_year_id,
            :_destroy]})
    end
end
