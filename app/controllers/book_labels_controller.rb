class BookLabelsController < ApplicationController
  before_action :set_book_label, only: [:show, :edit, :update, :destroy]

  # GET /book_labels
  # GET /book_labels.json
  def index
    @grade_level = params[:grade] ? GradeLevel.find(params[:grade]) : GradeLevel.first
    @grade_sections = @grade_level.grade_sections.with_academic_year_id AcademicYear.current
  end

  # GET /book_labels/1
  # GET /book_labels/1.json
  def show
  end

  # GET /book_labels/new
  def new
    @book_label = BookLabel.new
  end

  # GET /book_labels/1/edit
  def edit
  end

  # POST /book_labels
  # POST /book_labels.json
  def create
    @book_label = BookLabel.new(book_label_params)

    respond_to do |format|
      if @book_label.save
        format.html { redirect_to @book_label, notice: 'Book label was successfully created.' }
        format.json { render :show, status: :created, location: @book_label }
      else
        format.html { render :new }
        format.json { render json: @book_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_labels/1
  # PATCH/PUT /book_labels/1.json
  def update
    respond_to do |format|
      if @book_label.update(book_label_params)
        format.html { redirect_to @book_label, notice: 'Book label was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_label }
      else
        format.html { render :edit }
        format.json { render json: @book_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_labels/1
  # DELETE /book_labels/1.json
  def destroy
    @book_label.destroy
    respond_to do |format|
      format.html { redirect_to book_labels_url, notice: 'Book label was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_label
      @book_label = BookLabel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_label_params
      params.require(:book_label).permit(:grade_section_id, :student_id, :name)
    end
end
