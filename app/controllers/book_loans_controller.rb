class BookLoansController < ApplicationController
  before_action :set_book_loan, only: [:show, :edit, :update, :destroy]

  # GET /book_loans
  # GET /book_loans.json
  def index
    items_per_page = 30
    if params[:student].present?
      @student = Student.where("name LIKE ?", "%#{params[:student]}%").first
      if @student.present?
        @book_loans = BookLoan.includes([:student])
                        .where(academic_year:AcademicYear.current)
                        .where(student: @student)
      else
        @error = "Student with name like #{params[:student]} was not found."
      end
    elsif params[:teacher].present?
      @teacher = Employee.where("lower(name) LIKE ?", "%#{params[:teacher].downcase}%").first
      puts "#{params[:teacher]} => #{@teacher.try(:name) || 'N/A'}"
      if @teacher.present?
        @book_loans = BookLoan.includes([:employee])
                        .where(academic_year:AcademicYear.current)
                        .where(employee: @teacher)
      else
        @error = "Teacher with name like #{params[:teacher]} was not found."
      end
    elsif params[:student_id].present?
      @student = Student.find(params[:student_id])
      if @student.present?
        @book_loans = BookLoan.includes([:student])
                        .where(academic_year:AcademicYear.current)
                        .where(student: @student)
      else
        @error = "Something went awry... I'm confused."
      end
    elsif params[:employee_id].present?
      @teacher = Employee.find(params[:employee_id])
      puts "#{params[:teacher]} => #{@teacher.try(:name) || 'N/A'}"
      if @teacher.present?
        @book_loans = BookLoan.includes([:employee])
                        .where(academic_year:AcademicYear.current)
                        .where(employee: @teacher)
      else
        @error = "Something went awry... I'm confused."
      end
    else
      @book_loans = BookLoan.includes([:employee,:student])
                      .where(academic_year:AcademicYear.current)
    end

    # if params[:grade].present? and params[:grade].upcase != 'ALL'
    #   @grade_level = GradeLevel.find params[:grade]
    #   @book_loans = @book_loans.where(grade_level:@grade_level).includes([:book_title])
    # end

    if @book_loans.present?
      if params[:year].present?
        @academic_year = AcademicYear.find_by_slug params[:year]
        @book_loans = @book_loans.where(academic_year:@academic_year) if params[:year].upcase != 'ALL'
      else
        @book_loans = @book_loans.where(academic_year:current_academic_year_id)
      end

      if params[:category].present? and params[:category].upcase != 'ALL'
        @category = BookCategory.find_by_code params[:category]
        @book_loans = @book_loans.where(book_category:@category)
      end

      @book_loans = @book_loans.paginate(page: params[:page], per_page: @items_per_page)
    end
  end

  # GET /book_loans/1
  # GET /book_loans/1.json
  def show
  end

  # GET /book_loans/new
  def new
    @book_loan = BookLoan.new
  end

  # GET /book_loans/1/edit
  def edit
  end

  # POST /book_loans
  # POST /book_loans.json
  def create
    @book_loan = BookLoan.new(book_loan_params)

    respond_to do |format|
      if @book_loan.save
        format.html { redirect_to @book_loan, notice: 'Book loan was successfully created.' }
        format.json { render :show, status: :created, location: @book_loan }
      else
        format.html { render :new }
        format.json { render json: @book_loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_loans/1
  # PATCH/PUT /book_loans/1.json
  def update
    respond_to do |format|
      if @book_loan.update(book_loan_params)
        format.html { redirect_to @book_loan, notice: 'Book loan was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_loan }
      else
        format.html { render :edit }
        format.json { render json: @book_loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_loans/1
  # DELETE /book_loans/1.json
  def destroy
    @book_loan.destroy
    respond_to do |format|
      format.html { redirect_to book_loans_url, notice: 'Book loan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_loan
      @book_loan = BookLoan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_loan_params
      params.require(:book_loan).permit(:book_copy_id, :book_edition_id, :book_title_id, :user_id, :book_category_id, :loan_type_id, :out_date, :due_date, :academic_year_id)
    end
end
