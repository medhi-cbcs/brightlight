class GradeSectionsController < ApplicationController
  before_action :set_grade_section, only: [:edit, :update, :destroy, :students, :courses, :assign, :add_students, :edit_labels]
  before_action :set_year, only: [:index, :show, :new, :edit, :students, :add_students]

  # GET /grade_sections
  # GET /grade_sections.json
  def index
    authorize! :read, GradeSection
    @grade_level = GradeLevel.find(params[:grade_level_id])
    @grade_sections = @grade_level.grade_sections.includes([:academic_year, :homeroom])
  end

  # GET /grade_sections/1
  # GET /grade_sections/1.json
  def show
    authorize! :read, GradeSection
    @grade_section = GradeSection.find(params[:id])
    @grade_level = @grade_section.grade_level
    @grade_sections = GradeSection.all.order(:grade_level_id, :id)
    @grade_level_ids = GradeLevel.all.pluck :id
    if params[:year]
      @gss = @grade_section.students_for_academic_year(params[:year])
      @academic_year = AcademicYear.find params[:year]
    else
      @gss = @grade_section.current_year_students
      @academic_year = AcademicYear.current
    end
    @homeroom = @grade_section.homeroom_for_academic_year(@academic_year.id)
    @textbooks = @grade_section.standard_books(@academic_year)
  end

  # GET /grade_sections/new
  def new
    authorize! :manage, GradeSection
    @grade_level = GradeLevel.find(params[:grade_level_id])
    @grade_section = @grade_level.grade_sections.new
  end

  # GET /grade_sections/1/edit
  def edit
    authorize! :update, @grade_section
    @grade_level =  @grade_section.grade_level
    @total_students = GradeSectionsStudent.number_of_students(@grade_section, @academic_year)
    @students = GradeSectionsStudent.where(academic_year:@academic_year,grade_section:@grade_section)
  end

  def edit_labels
    authorize! :update, @grade_section
    @book_labels = @grade_section.book_labels
    @students = @grade_section.students
  end

  def students
    authorize! :update, GradeSection
    @grade_level = @grade_section.grade_level
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

  def add_students
    authorize! :update, @grade_section
    academic_year_id = params[:year]
    params[:add].map {|id,on| Student.find(id)}.each do |student|
      @gss = GradeSectionsStudent.new(grade_section: @grade_section, student:student, academic_year_id: academic_year_id || current_academic_year_id)
      if @gss.save
        next
      else
        #render :students
        redirect_to students_grade_section_path, alert: 'Students already added' and return
      end
    end
    redirect_to grade_section_path(@grade_section, year:params[:year]), notice: 'Students successfully added'
  end

  # GET /grade_sections/1/courses
  def courses
    authorize! :read, GradeSection
    @course_sections = @grade_section.course_sections
  end

  # GET /grade_sections/1/courses
  def assign
    authorize! :update, @grade_section
    @book_labels = @grade_section.book_labels.where('name LIKE ?', "#{@grade_section.name}%")
    @students = @grade_section.students
  end

  # POST /grade_sections
  # POST /grade_sections.json
  def create
    authorize! :manage, GradeSection
    @grade_section = GradeSection.new(grade_section_params)

    respond_to do |format|
      if @grade_section.save
        format.html { redirect_to @grade_section, notice: 'Grade section was successfully created.' }
        format.json { render :show, status: :created, location: @grade_section }
      else
        format.html { render :new }
        format.json { render json: @grade_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grade_sections/1
  # PATCH/PUT /grade_sections/1.json
  def update
    authorize! :update, @grade_section
    respond_to do |format|
      if @grade_section.update(grade_section_params)
        format.html {
          if grade_section_params[:book_receipts_attributes].present?
            redirect_to book_receipts_path(gs:params[:gs], r:params[:r], year:params[:year]), notice: 'Books were successfully added to book receipt.'
          else
            if params[:year].present?
              redirect_to grade_section_path(@grade_section, year:params[:year]), notice: 'Grade section was successfully updated.'
            else
              redirect_to grade_section_path(@grade_section), notice: 'Grade section was successfully updated.'
            end
          end
        }
        format.json { render :show, status: :ok, location: @grade_section }
      else
        format.html {
          if grade_section_params[:book_receipts_attributes].present?
            redirect_to new_book_receipt_path(gs:params[:gs],r:params[:r],year:params[:year]), alert: 'Errors in adding books to book receipt'
          else
            render :edit
          end
        }
        format.json { render json: @grade_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grade_sections/1
  # DELETE /grade_sections/1.json
  def destroy
    authorize! :destroy, @grade_section
    @grade_section.destroy
    respond_to do |format|
      format.html { redirect_to grade_sections_url, notice: 'Grade section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade_section
      @grade_section = GradeSection.find(params[:id])
    end

    def set_year
      @year_id = params[:year] || AcademicYear.current_id
      @academic_year = AcademicYear.find(@year_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_section_params
      params.require(:grade_section).permit(:name, :homeroom_id,
                                           {:grade_sections_students_attributes => [:id, :student_id, :order_no, :_destroy]},
                                           {:book_receipts_attributes => [:id, :book_copy_id, :academic_year_id, :student_id,
                                                :book_edition_id, :grade_section_id, :grade_level_id, :roster_no, :copy_no,
                                                :issue_date, :initial_condition_id, :return_condition_id, :barcode, :notes,
                                                :grade_section_code, :grade_subject_code, :course_id, :course_text_id, :active,
                                                :_destroy]}
                                           )
    end
end
