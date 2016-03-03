class CourseSectionsController < ApplicationController
  before_action :set_course_section, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  # GET /course_sections
  # GET /course_sections.json
  def index
    @course = Course.find(params[:course_id])
    items_per_page = 20
    if params[:grade_id]
      @course_sections = CourseSection.with_grade_level(params[:grade_id]).paginate(page: params[:page], per_page: items_per_page)
    elsif params[:course_id]
      @course_sections = @course.course_sections
    end
  end

  # GET /course_sections/1
  # GET /course_sections/1.json
  def show
    @course = @course_section.course
  end

  # GET /course_sections/1/edit
  def edit
  end

  # POST /course_sections
  # POST /course_sections.json
  def create
    @course_section = CourseSection.new(course_section_params)

    respond_to do |format|
      if @course_section.save
        format.html { redirect_to @course_section, notice: 'Course section was successfully created.' }
        format.json { render :show, status: :created, location: @course_section }
      else
        format.html { render :new }
        format.json { render json: @course_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_sections/1
  # PATCH/PUT /course_sections/1.json
  def update
    respond_to do |format|
      if @course_section.update(course_section_params)
        format.html { redirect_to @course_section, notice: 'Course section was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_section }
      else
        format.html { render :edit }
        format.json { render json: @course_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_sections/1
  # DELETE /course_sections/1.json
  def destroy
    @course_section.destroy
    respond_to do |format|
      format.html { redirect_to course_sections_url, notice: 'Course section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_section
      @course_section = CourseSection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_section_params
      params.require(:course_section).permit(:name, :instructor_id)
    end
end
