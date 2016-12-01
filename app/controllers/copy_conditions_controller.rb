class CopyConditionsController < ApplicationController
  before_action :set_copy_condition, only: [:show, :edit, :update, :destroy]
  include ApplicationHelper

  # GET /copy_conditions
  # GET /copy_conditions.json
  def index
    @grade_level_ids = GradeLevel.all.collect(&:id)
    @grade_sections = GradeSection.all
    @grade_sections_ids = @grade_sections.collect(&:id)
    if params[:s].present?
      @grade_section = @grade_sections.where(id:params[:s]).first
      @grade_level = @grade_section.grade_level
    end
    if params[:l].present?
      @label = BookLabel.find(params[:l])
      @copy_conditions = CopyCondition.current_year.for_label(params[:l])
    end
  end

  # GET /copy_conditions/1
  # GET /copy_conditions/1.json
  def show
  end

  # GET /copy_conditions/new
  def new
    @copy_condition = CopyCondition.new    
    @academic_year = AcademicYear.current
  end

  # GET /copy_conditions/1/edit
  def edit
    @user = User.where(id:@copy_condition.user_id).first
  end

  # POST /copy_conditions
  # POST /copy_conditions.json
  def create
    # @book_copy = BookCopy.copy_with_barcode(copy_condition_params[:barcode])
    @copy_condition = CopyCondition.new(copy_condition_params)
    @academic_year_id = AcademicYear.current_id
    respond_to do |format|
      if @copy_condition.save
        format.html { redirect_to book_copy_conditions_url(@book_copy.id), notice: 'Copy condition was successfully updated.' }
        format.json { render :show, status: :created, location: @copy_condition }
      else
        format.html { render :new }
        format.json { render json: @copy_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /book_copies/1/copy_conditions/1/check
  def check
    @book_copy = BookCopy.find params[:id]
    @copy_condition = CopyCondition.new
    @academic_year = @book_copy.latest_copy_condition.try(:academic_year) || AcademicYear.current
  end

  # POST /book_copies/1/copy_conditions/1/check_update
  # POST /book_copies/1/copy_conditions/1/check_update.json
  def check_update
    @book_copy = BookCopy.find params[:id]
    @copy_condition = CopyCondition.new(copy_condition_params)

    respond_to do |format|
      old_copy_condition = @book_copy.latest_copy_condition
      if @copy_condition.save
        student_book = StudentBook.where(academic_year:AcademicYear.current_id).where(book_copy:@book_copy).take
        student_book.update(initial_copy_condition_id: @copy_condition.book_condition_id) if student_book.present?        
        old_copy_condition.update(end_date: Date.today) if old_copy_condition.present?

        format.html { redirect_to book_copy_conditions_url(@book_copy.id), notice: 'Copy condition was successfully updated.' }
        format.json { render :show, status: :created, location: @copy_condition }
      else
        format.html { render :check }
        format.json { render json: @copy_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /copy_conditions/1
  # PATCH/PUT /copy_conditions/1.json
  def update
    @book_copy = @copy_condition.book_copy
    respond_to do |format|
      if @copy_condition.update(copy_condition_params)
        format.html { redirect_to book_copy_conditions_url(@book_copy.id), notice: 'Copy condition was successfully updated.' }
        format.json { render :show, status: :ok, location: @copy_condition }
      else
        format.html { render :edit }
        format.json { render json: @copy_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /copy_conditions/1
  # DELETE /copy_conditions/1.json
  def destroy
    @copy_condition.destroy
    respond_to do |format|
      format.html {
        @book_copy = @copy_condition.book_copy
        redirect_to book_copy_conditions_url(@book_copy.id), notice: 'Copy condition was successfully destroyed.'
      }
      format.json { head :no_content }
      format.js { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_copy_condition
      @copy_condition = CopyCondition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def copy_condition_params
      params.require(:copy_condition).permit(:book_copy_id, :book_condition_id, :academic_year_id, :barcode, :notes, :post, :user_id, :start_date, :end_date, :deleted_flag)
    end
end
