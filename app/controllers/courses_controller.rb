class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /courses
  # GET /courses.json
  def index
    items_per_page = 20
    if params[:grade]
      @courses = Course.with_grade_level(params[:grade]).paginate(page: params[:page], per_page: items_per_page)
      @grade = GradeLevel.where(id: params[:grade])
    else
      @courses = Course.paginate(page: params[:page], per_page: items_per_page)
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    authorize! :manage, Course
    @course = Course.new
    3.times { @course.course_sections.build }
    3.times { @course.course_texts.build }
  end

  # GET /courses/1/edit
  def edit
    authorize! :update, @course
    3.times { @course.course_sections.build } if @course.course_sections.empty?
    3.times { @course.course_texts.build } if @course.course_texts.empty?
    @book_titles = BookTitle.all
  end

  # POST /courses
  # POST /courses.json
  def create
    authorize! :manage, Course
    @course = Course.new(course_params)
    @course.course_sections.each do |course_section|
      course_section.name = "#{@course.name} #{course_section.grade_section.name}"
    end

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    authorize! :update, @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    authorize :destroy, @course
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :number, :description, :grade_level_id, :academic_year_id, :academic_term_id, :employee_id,
                                    {:academic_term_ids => []},
                                    {:course_sections_attributes => [:id, :name, :grade_section_id, :instructor_id, :_destroy]},
                                    {:course_texts_attributes => [:id, :book_title_id, :order_no, :_destroy]})
    end
end
