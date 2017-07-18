class GradeLevelsController < ApplicationController
  before_action :set_grade_level, only: [:show, :edit, :update, :destroy, :edit_labels]
  before_action :set_year, only: [:index, :show, :new, :edit]

  # GET /grade_levels
  # GET /grade_levels.json
  def index
    authorize! :read, GradeLevel
    # This preloading cuts down the number of database calls to just 4 calls regardless the numbers of grade sections we have

    if params[:year].blank? || params[:year].to_i >= AcademicYear.current_id
      @grade_levels = GradeLevel.includes(grade_sections: [:homeroom])
    else
      @grade_levels = GradeLevel.includes(grade_section_histories: [:homeroom])
                        .where(grade_section_histories: {academic_year_id: params[:year]})
                        .order('grade_levels.id, grade_section_histories.name')
    end
  end

  # GET /grade_levels/1
  # GET /grade_levels/1.json
  def show
    authorize! :read, GradeLevel
    if params[:year].blank? || params[:year].to_i == AcademicYear.current_id
      @grade_sections = @grade_level.grade_sections.order(:id).includes([:homeroom])
    else
      @grade_sections = @grade_level.grade_section_histories
                          .where(grade_section_histories: {academic_year_id: params[:year]})
                          .order(:id).includes([:homeroom])
    end
  end

  # GET /grade_levels/new
  def new
    authorize! :manage, GradeLevel
    @grade_level = GradeLevel.new
    3.times { @grade_level.grade_sections.build }
  end

  # GET /grade_levels/1/edit
  def edit
    authorize! :update, @grade_level
    @grade_sections = @grade_level.grade_sections.includes([:homeroom])
  end

  # POST /grade_levels
  # POST /grade_levels.json
  def create
    authorize! :manage, GradeLevel
    @grade_level = GradeLevel.new(grade_level_params)

    respond_to do |format|
      if @grade_level.save
        format.html { redirect_to @grade_level, notice: 'Grade level was successfully created.' }
        format.json { render :show, status: :created, location: @grade_level }
      else
        format.html { render :new }
        format.json { render json: @grade_level.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_labels
    authorize! :update, @grade_level
    section_name = params[:section]
    # @book_labels = @grade_level.book_labels.where('name LIKE ?', "#{section_name}%")
    # @grade_section = @grade_level.grade_sections.where(name:section_name).first
    @grade_section = GradeSection.find params[:section]
    @book_labels = @grade_section.book_labels
    @students = @grade_section.students
  end

  def add_standard_books
    authorize! :update, @grade_level
    if params[:add]
      params[:add].map {|id,on| BookEdition.find(id)}.each do |edition|
        @book_title.book_editions << edition
      end
      redirect_to @book_title, notice: 'Standard books successfully added'
    else
      flash[:warning] = 'You must select at least one.'
      redirect_to :back
    end
  end

  def archive
    authorize! :update, @grade_level

    GradeSection.all.each do |grade_section|
      gsh = GradeSectionHistory.new(
              grade_level_id: grade_section.grade_level_id,
              grade_section_id: grade_section.id,
              name: grade_section.name,
              homeroom_id: grade_section.homeroom_id,
              assistant_id: grade_section.assistant_id,
              academic_year_id: grade_section.academic_year_id,
              subject_code: grade_section.subject_code,
              parallel_code: grade_section.parallel_code,
              capacity: grade_section.capacity,
              notes: grade_section.notes
      )
      gsh.save
    end
    @message = "Archive completed"

    respond_to do |format|
      format.js { head :no_content }
    end
  end

  # PATCH/PUT /grade_levels/1
  # PATCH/PUT /grade_levels/1.json
  def update
    authorize! :update, @grade_level
    respond_to do |format|
      if @grade_level.update(grade_level_params)
        editing_labels = grade_level_params[:book_labels_attributes].present?
        format.html {
          if editing_labels
            redirect_to book_labels_path, notice: 'Labels were successfully updated.'
          else
            redirect_to @grade_level, notice: 'Grade level was successfully updated.'
          end
        }
        format.json { render :show, status: :ok, location: @grade_level }
      else
        format.html { render :edit }
        format.json { render json: @grade_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grade_levels/1
  # DELETE /grade_levels/1.json
  def destroy
    authorize! :destroy, @grade_level
    @grade_level.destroy
    respond_to do |format|
      format.html { redirect_to grade_levels_url, notice: 'Grade level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade_level
      @grade_level = GradeLevel.find(params[:id])
    end

    def set_year
      @year_id = params[:year] || current_academic_year_id
      @academic_year = AcademicYear.find(@year_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_level_params
      params.require(:grade_level).permit(:name, :order_no,
                                         {:grade_sections_attributes => [:name, :homeroom_id, :academic_year_id, :_destroy, :id]},
                                         {:book_labels_attributes => [:id, :name, :grade_section_id, :student_id, :_destroy]})
    end
end
