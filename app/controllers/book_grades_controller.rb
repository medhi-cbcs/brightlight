class BookGradesController < ApplicationController
  before_action :set_book_grade, only: [:show, :edit, :update, :destroy]

  # GET /book_grades
  # GET /book_grades.json
  def index
    @book_grades = BookGrade.all
  end

  # GET /book_grades/1
  # GET /book_grades/1.json
  def show
  end

  # GET /book_grades/new
  def new
    @book_grade = BookGrade.new
  end

  # GET /book_grades/1/edit
  def edit
  end

  # POST /book_grades
  # POST /book_grades.json
  def create
    @book_grade = BookGrade.new(book_grade_params)

    respond_to do |format|
      if @book_grade.save
        format.html { redirect_to @book_grade, notice: 'Book grade was successfully created.' }
        format.json { render :show, status: :created, location: @book_grade }
      else
        format.html { render :new }
        format.json { render json: @book_grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_grades/1
  # PATCH/PUT /book_grades/1.json
  def update
    respond_to do |format|
      if @book_grade.update(book_grade_params)
        format.html { redirect_to @book_grade, notice: 'Book grade was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_grade }
      else
        format.html { render :edit }
        format.json { render json: @book_grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_grades/1
  # DELETE /book_grades/1.json
  def destroy
    @book_grade.destroy
    respond_to do |format|
      format.html { redirect_to book_grades_url, notice: 'Book grade was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_grade
      @book_grade = BookGrade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_grade_params
      params.require(:book_grade).permit(:book_id, :book_condition_id, :academic_year_id, :notes, :graded_by, :notes)
    end
end
