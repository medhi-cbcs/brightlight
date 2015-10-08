class BookAssignmentsController < ApplicationController
  before_action :set_book_assignment, only: [:show, :edit, :update, :destroy]

  # GET /book_assignments
  # GET /book_assignments.json
  def index
    @book_assignments = BookAssignment.all
  end

  # GET /book_assignments/1
  # GET /book_assignments/1.json
  def show
  end

  # GET /book_assignments/new
  def new
    @book_assignment = BookAssignment.new
  end

  # GET /book_assignments/1/edit
  def edit
  end

  # POST /book_assignments
  # POST /book_assignments.json
  def create
    @book_assignment = BookAssignment.new(book_assignment_params)

    respond_to do |format|
      if @book_assignment.save
        format.html { redirect_to @book_assignment, notice: 'Book assignment was successfully created.' }
        format.json { render :show, status: :created, location: @book_assignment }
      else
        format.html { render :new }
        format.json { render json: @book_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_assignments/1
  # PATCH/PUT /book_assignments/1.json
  def update
    respond_to do |format|
      if @book_assignment.update(book_assignment_params)
        format.html { redirect_to @book_assignment, notice: 'Book assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_assignment }
      else
        format.html { render :edit }
        format.json { render json: @book_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_assignments/1
  # DELETE /book_assignments/1.json
  def destroy
    @book_assignment.destroy
    respond_to do |format|
      format.html { redirect_to book_assignments_url, notice: 'Book assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_assignment
      @book_assignment = BookAssignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_assignment_params
      params.require(:book_assignment).permit(:book_id, :student_id, :academic_year_id, :course_text_id, :issue_date, :return_date, :initial_condition_id, :end_condition_id, :status_id)
    end
end
