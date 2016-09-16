class BookLoansController < ApplicationController
  before_action :set_book_loan, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:update]

  # GET /book_loans
  # GET /book_loans.json
  def index
    items_per_page = 30
    if params[:student].present?
      @student = Student.where("lower(name) LIKE ?", "%#{params[:student].downcase}%").first
      if @student.present?
        @book_loans = BookLoan.includes([:student])
                        .where(academic_year_id:AcademicYear.current_id)
                        .where(student: @student)
      else
        @error = "Student with name like #{params[:student]} was not found."
      end
    elsif params[:teacher].present?
      @teacher = Employee.where("lower(name) LIKE ?", "%#{params[:teacher].downcase}%").first
      if @teacher.present?
        @book_loans = BookLoan.includes([:employee])
                        .where(academic_year_id:AcademicYear.current_id)
                        .where(employee: @teacher)
      else
        @error = "Teacher with name like #{params[:teacher]} was not found."
      end
    elsif params[:student_id].present?
      @student = Student.find(params[:student_id])
      if @student.present?
        @book_loans = BookLoan.includes([:student])
                        .where(academic_year_id:AcademicYear.current_id)
                        .where(student: @student)
      else
        @error = "Something went awry... I'm confused."
      end
    elsif params[:employee_id].present?
      @teacher = Employee.find(params[:employee_id])
      if @teacher.present?
        @book_loans = BookLoan.includes([:employee])
                        .where(academic_year_id:AcademicYear.current_id)
                        .where(employee: @teacher)
      else
        @error = "Something went awry... I'm confused."
      end
    else
      @book_loans = BookLoan.includes([:employee,:student])
                      .where(academic_year_id:AcademicYear.current_id)
    end

    # if params[:grade].present? and params[:grade].upcase != 'ALL'
    #   @grade_level = GradeLevel.find params[:grade]
    #   @book_loans = @book_loans.where(grade_level:@grade_level).includes([:book_title])
    # end

    if @book_loans.present?
      if params[:year].present?
        @academic_year = AcademicYear.find params[:year]
        @book_loans = @book_loans.where(academic_year:@academic_year) if params[:year].upcase != 'ALL'
      else
        @book_loans = @book_loans.where(academic_year:AcademicYear.current_id)
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
      format.html { redirect_to book_loans_path, notice: 'Book loan was successfully destroyed.' }
      format.json { head :no_content }
      format.js { head :no_content }
    end
  end

  def borrowers
    authorize! :read, BookLoan
    @borrowers = Employee.joins(:book_loans).where(book_loans: {academic_year: params[:year]}).order(:name).uniq
    respond_to :json
  end

  #### This section deals with teacher's loan

  # GET book_loans/teachers
  def teachers
    authorize! :read, BookLoan
    @teachers = Employee.joins(:book_loans).where(book_loans: {academic_year_id: AcademicYear.current_id}).order(:name).uniq
    @employees = Employee.where('email is not null').order(:name)
  end

  # GET employees/:employee_id/book_loans
  def list
    authorize! :read, BookLoan
    @teacher = Employee.find params[:employee_id]
    if @teacher.present?
      @book_loans = BookLoan.includes([:employee]).includes([:book_copy,:book_edition])
                      .where(employee: @teacher)
    else
      @error = "Teacher with name like #{params[:teacher]} was not found."
    end

    # academic_year
    if params[:year].present? && params[:year].downcase != 'all'
      @academic_year = AcademicYear.find params[:year]
      @book_loans = @book_loans.where(academic_year:@academic_year)
    elsif params[:year].blank?
      @academic_year = AcademicYear.current
      @book_loans = @book_loans.where(academic_year:@academic_year)
    elsif params[:year].present? && params[:year].downcase == 'all'
      @book_loans = @book_loans.order('academic_year_id DESC')
    end

    # For Menu
    @teachers = Employee.joins(:book_loans).where(book_loans: {academic_year_id: @academic_year.id}).order(:name).uniq

    # Checked filter
    if params[:checked] == 't'
      @book_loans = @book_loans.where(return_status:'R')
    elsif params[:checked] == 'f'
      @book_loans = @book_loans.where(return_status:nil)
    end

    respond_to do |format|
      format.html do
        @items_per_page = 30
        @book_loans = @book_loans.paginate(page: params[:page], per_page: @items_per_page)
      end
      format.pdf do
        render pdf:         "Teacher's Books -#{@teacher.name}.pdf",
               disposition: 'inline',
               template:    'book_loans/list.pdf.slim',
               layout:      'pdf.html',
               header:      { left: "Teacher's Books", right: '[page] of [topage]' },
               show_as_html: params.key?('debug')
      end
    end
  end

  def show_tm
    @teacher = Employee.find params[:employee_id]
    @book_loan = BookLoan.find params[:id]
  end

  def new_tm
    authorize! :manage, BookLoan
    @teacher = Employee.find params[:employee_id]
    @book_loan = BookLoan.new
  end

  def scan
    authorize! :scan, BookLoan
    @teacher = Employee.find params[:employee_id]
  end

  # PUT /employees/:employee_id/book_loans/:id
  def update_tm
    authorize! :manage, BookLoan
    @teacher = Employee.find params[:employee_id]
    @book_loan = BookLoan.find params[:id]
    borrower_matched = @teacher == @book_loan.employee

    respond_to do |format|
      if borrower_matched and @book_loan.update(book_loan_params)
        format.html { redirect_to employee_book_loan_path(employee_id:@teacher.id, id:@book_loan.id) }
        format.json { render :show, status: :ok, location: @book_loan }
      else
        format.html { render :edit_tm }
        format.json { render json: @book_loan.errors, status: :unprocessable_entity }
      end

    end
  end

  def create_multiple
    authorize! :manage, BookLoan
    @current_year = AcademicYear.current_id

    params[:book_loans].each do |key, values|
      book_loan = BookLoan.where(academic_year_id:@current_year).where(book_copy_id:values[:book_copy_id]).take
      book_loan.update_attribute(:return_date, values[:return_date])
      book_loan.update_attribute(:user_id, values[:user_id])
      book_loan.update_attribute(:notes, values[:notes])
      book_loan.update_attribute(:student_no, values[:student_no])
    end
    flash[:notice] = "Book conditions updated!"
    if params[:student_form].present?
      redirect_to by_student_student_books_path(s:params[:grade_section_id],g:params[:grade_level_id],st:params[:st])
    else
      redirect_to by_title_student_books_path(s:params[:grade_section_id],g:params[:grade_level_id],t:params[:title])
    end
  end

  def initialize_teachers
    authorize! :manage, BookLoan
    academic_year_id = params[:teacher_loan_year].to_i

    respond_to do |format|
      format.js do
        if BookLoan.where(academic_year_id:academic_year_id).where.not(employee_id:nil).count > 0
          @error = "Error: records are not empty for the academic year #{AcademicYear.find(academic_year_id).name}"
        else
          BookLoan.initialize_teacher_loans_from_previous_year academic_year_id-1, academic_year_id
          @message = "Initialization completed."
        end
      end
    end
  end

  # POST /employees/1/book_loans/move_all.js
  def move_all
    authorize! :manage, BookLoan
    from = Employee.find params[:from_teacher]
    to = Employee.find params[:to_teacher].to_i
    from_year = params[:from_year].to_i
    to_year = params[:to_year].to_i
    BookLoan.move_all_books(from:from,to:to, from_year:from_year, to_year:to_year)

    respond_to do |format|
      format.js
    end
  end

  # POST /employees/1/book_loans/list_action.js
  def list_action
    authorize! :manage, BookLoan
    employee = Employee.find params[:employee_id]
    target = Employee.find params[:to_teacher]
    year = AcademicYear.find params[:to_year]
    loan_ids = params[:add].map &:first
    completed = []
    ids_to_remove = []
    if params[:move]
      BookLoan.where(id:loan_ids).each do |loan|
        success = loan.move_book to:target, to_year:year
        completed << loan.id.to_s if success
        ids_to_remove << loan.id.to_s if success and year == loan.academic_year
      end
      failed = loan_ids - completed
    elsif params[:delete]
      BookLoan.where(id:loan_ids).delete_all
      ids_to_remove = loan_ids
    end
    ids_to_uncheck = completed - ids_to_remove
    @rows_to_remove = ids_to_remove.present? ? ids_to_remove.map{|id| '#row-'+id.to_s}.join(', ') : ""
    @failed_barcodes = failed.present? ? failed.map {|x| BookLoan.where(id:x).take.try(:barcode)} : ""
    @rows_to_uncheck = ids_to_uncheck.present? ? ids_to_uncheck.map{|id| '#add_'+id.to_s}.join(', ') : ""
    respond_to :js
  end

 # GET /book_loans/teacher_receipt?tid=1&year=1
  def teacher_receipt
    @academic_year = AcademicYear.find params[:year]
    @year_prev = @academic_year.name.slice!(0..3)
    @year_next = @academic_year.name.slice!(1..4)  
    # Use the specified template or the default one if none given
    if params[:template].present?
      @template = Template.find params[:template]
    else
      @template = Template.where(target:'teacher_book_receipt').where(active:'true').take
    end

    if params[:employee_id].present?
      @teacher = Employee.find params[:employee_id]
      @book_loans = BookLoan.select([BookTitle.arel_table[:title], BookTitle.arel_table[:subject], BookEdition.arel_table[:authors],BookEdition.arel_table[:publisher], BookEdition.arel_table[:isbn13], BookEdition.arel_table[:isbn10], BookLoan.arel_table[:notes]])
      .where(BookLoan.arel_table[:academic_year_id].eq(16).and(BookLoan.arel_table[:employee_id].eq(6)))      .joins(BookLoan.arel_table.join(BookEdition.arel_table).on(BookEdition.arel_table[:id].eq(BookLoan.arel_table[:book_edition_id])).join_sources)
      .joins(BookLoan.arel_table.join(BookTitle.arel_table).on(BookTitle.arel_table[:id].eq(BookLoan.arel_table[:book_title_id])).join_sources)
      .group(BookTitle.arel_table[:title], BookTitle.arel_table[:subject], BookEdition.arel_table[:authors],BookEdition.arel_table[:publisher], BookEdition.arel_table[:isbn13], BookEdition.arel_table[:isbn10],BookLoan.arel_table[:notes])
        
        if @template
        @template.placeholders = {
          teacher_name: @teacher.name,
          year_prev: @year_prev,
          year_next: @year_next
            }
        end
    end
  end
  ####

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_loan
      @book_loan = BookLoan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_loan_params
      params.require(:book_loan).permit(:book_copy_id, :book_edition_id, :book_title_id, :user_id, :book_category_id,
        :loan_type_id, :out_date, :due_date, :academic_year_id, :barcode, :return_date, :return_status, :notes)
    end
    
    
   
end
