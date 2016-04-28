class GradeSectionsController < ApplicationController
  before_action :set_grade_section, only: [:edit, :update, :destroy, :students, :courses, :assign, :add_students]
  before_action :set_year, only: [:index, :show, :new, :edit]

  # GET /grade_sections
  # GET /grade_sections.json
  def index
    @grade_level = GradeLevel.find(params[:grade_level_id])
    @year_id = params[:year] || current_academic_year_id
    @grade_sections = @grade_level.grade_sections.includes([:academic_year, :homeroom])
  end

  # GET /grade_sections/1
  # GET /grade_sections/1.json
  def show
    @grade_section = GradeSection.find_by_slug(params[:id])
    @grade_level = @grade_section.grade_level
    @textbooks = @grade_section.standard_books
    @students = @grade_section.current_students
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
    @total_students = GradeSectionsStudent.number_of_students(@grade_section, current_academic_year_id)
    @students = GradeSectionsStudent.where(academic_year:AcademicYear.current).where(grade_section:@grade_section)
  end

  def students
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
    academic_year_id = current_academic_year_id
    params[:add].map {|id,on| Student.find(id)}.each do |student|
      @grade_section.add_student(student, academic_year_id)
    end
    redirect_to @grade_section, notice: 'Students successfully added'
  end

  # GET /grade_sections/1/courses
  def courses
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
        format.html { redirect_to @grade_section, notice: 'Grade section was successfully updated.' }
        format.json { render :show, status: :ok, location: @grade_section }
      else
        format.html { render :edit }
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
      @grade_section = GradeSection.find_by_slug(params[:id])
    end

    def set_year
      @year_id = params[:year] || current_academic_year_id
      @academic_year = AcademicYear.find(@year_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_section_params
      params.require(:grade_section).permit(:name, :homeroom_id,
                                           {:grade_sections_students_attributes => [:id, :student_id, :order_no, :_destroy]})
    end
end
