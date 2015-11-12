class GradeSectionsController < ApplicationController
  before_action :set_grade_section, only: [:show, :edit, :update, :destroy]

  # GET /grade_sections
  # GET /grade_sections.json
  def index
    @grade_level = GradeLevel.find(params[:grade_level_id])
    @grade_sections = @grade_level.grade_sections
  end

  # GET /grade_sections/1
  # GET /grade_sections/1.json
  def show
  end

  # GET /grade_sections/new
  def new
    @grade_level = GradeLevel.find(params[:grade_level_id])
    @grade_section = @grade_level.grade_sections.new
  end

  # GET /grade_sections/1/edit
  def edit
  end

  # POST /grade_sections
  # POST /grade_sections.json
  def create
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_section_params
      params.require(:grade_section).permit(:name, :homeroom_id, 
                                           {:grade_sections_students_attributes => [:id, :student_id, :order_no, :_destroy]})
    end
end
