class BookFinesController < ApplicationController
  before_action :set_book_fine, only: [:show, :edit, :update, :destroy]

  autocomplete :student, :name

  # GET /book_fines
  # GET /book_fines.json
  def index
    authorize! :manage, BookFine
    if params[:year].present?
      @academic_year = AcademicYear.find params[:year]
    else
      @academic_year = AcademicYear.current
    end

    # TODO: Optimize with eager loading
    #   @students = Student.eager_load([:book_fines,:grade_sections_students]).where("book_fines.academic_year_id = ? and grade_sections_students.academic_year_id = ?", @academic_year.id, @academic_year.id)

    @book_fines = BookFine.where(academic_year:@academic_year).order(:student_id)
    @students = Student.joins(:book_fines)
      .where(book_fines: {academic_year: @academic_year})
      .uniq
      .eager_load(:grade_sections_students)
      .where('grade_sections_students.academic_year_id = ?', @academic_year.id)
      .eager_load(:grade_sections)
      .order(:name)
    @grade_sections = GradeSection.joins(:grade_sections_students)
                      .where('grade_sections_students.student_id in (SELECT DISTINCT "students".id FROM "students" INNER JOIN "book_fines" ON "book_fines"."student_id" = "students"."id" WHERE "book_fines"."academic_year_id" = ?) and grade_sections_students.academic_year_id = ?', @academic_year.id, @academic_year.id)
                      .sort.uniq
    @dollar_rate = Currency.dollar_rate
    if params[:st].present?
      @student = Student.where(id:params[:st]).take
      @book_fines = @book_fines.where(student_id:params[:st])
      @total_idr_amount = @book_fines.reduce(BigDecimal.new("0")){|sum,f| sum + ( f.currency=="USD" ? f.fine * @dollar_rate : f.fine )}
      tag = Digest::MD5.hexdigest "#{@academic_year.id}-#{@student.id}-#{@total_idr_amount}"
      # Take the last created invoice with the tag, or create one if none found
      invoice = Invoice.where(tag: tag).order('created_at DESC').take
      @paid = invoice.paid if invoice.present?
    end
    if params[:s].present?
      @grade_section = GradeSection.where(id:params[:s]).take
      @book_fines = @book_fines.where("student_id in
          (SELECT students.id FROM students INNER JOIN grade_sections_students
          ON grade_sections_students.student_id = students.id
          WHERE grade_sections_students.grade_section_id = ?
          AND grade_sections_students.academic_year_id = ?)", @grade_section.id, @academic_year.id)
    end
    @book_fines = @book_fines.includes([:student,:old_condition,:new_condition]).includes(:book_copy => :book_edition).includes(:book_copy => :book_label)
  end

  # GET /book_fines/1
  # GET /book_fines/1.json
  def show
    authorize! :manage, BookFine
    @book_copy = @book_fine.book_copy
    @book_edition = @book_copy.try(:book_edition)
    @student = @book_fine.student
    @academic_year = AcademicYear.current
  end

  # GET /book_fines/new
  def new
    authorize! :manage, BookFine
    @book_fine = BookFine.new
  end

  # GET /book_fines/1/edit
  def edit
    authorize! :manage, BookFine
    @book_copy = @book_fine.book_copy
    @book_edition = @book_copy.try(:book_edition)
    @book_title = @book_edition.try(:title)
    @currency = @book_edition.try(:currency)
    @price = @book_edition.try(:price)
    @barcode = @book_copy.try(:barcode)
  end

  # POST /book_fines
  # POST /book_fines.json
  def create
    authorize! :manage, BookFine
    @book_fine = BookFine.new(book_fine_params)

    respond_to do |format|
      if @book_fine.save
        format.html { redirect_to @book_fine, notice: 'Book fine was successfully created.' }
        format.json { render :show, status: :created, location: @book_fine }
      else
        format.html { render :new }
        format.json { render json: @book_fine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_fines/1
  # PATCH/PUT /book_fines/1.json
  def update
    authorize! :manage, BookFine
    respond_to do |format|
      if @book_fine.update(book_fine_params)
        format.html { redirect_to @book_fine, notice: 'Book fine was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_fine }
      else
        format.html { render :edit }
        format.json { render json: @book_fine.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /book_fines/current
  def current
    authorize! :manage, BookFine
  end

  # POST /book_fines/calculate
  def calculate
    authorize! :manage, BookFine    
    academic_year_id = params[:fines_academic_year].to_i

    respond_to do |format|
      format.js do
        grades = params[:fines_grade]
        if grades[:all].present?
          BookFine.collect_fines academic_year_id
        else
          grades.each { |grade| BookFine.collect_fines_for_grade_level grade[0], year:academic_year_id }
        end 
      end
    end
  end

  # GET /book_fines/notification?st=1&year=1
  def notification
    authorize! :manage, BookFine
    @academic_year = AcademicYear.find params[:year]

    # Use the specified template or the default one if none given
    if params[:template].present?
      @template = Template.find params[:template]
    else
      @template = Template.where(target:'book_fine').where(active:'true').take
    end

    if params[:st].present?
      @student = Student.where(id:params[:st]).take
      @book_fines = BookFine.where(academic_year:@academic_year).where(student_id:params[:st])
      if @template
        @template.placeholders = {
          student_name: @student.name,
          grade_section: @student.current_grade_section.name
        }
      end
    end
  end

  # GET /book_fines/payment?st=1
  def payment
    authorize! :manage, BookFine
    @academic_year = AcademicYear.current
    @student = Student.where(id:params[:st]).includes(:grade_sections_students).take
    @book_fines = BookFine.where(academic_year:@academic_year).where(student_id:params[:st]).includes([:book_copy, :old_condition, :new_condition])
    @currency = "Rp"
    @dollar_rate = Currency.dollar_rate
    @total_idr_amount = @book_fines.reduce(BigDecimal.new("0")){|sum,f| sum + ( f.currency=="USD" ? f.fine * @dollar_rate : f.fine )}
    @invoice = BookFine.create_invoice_for student:@student,
                  total_amount: @total_idr_amount,
                  academic_year: @academic_year,
                  exchange_rate: @dollar_rate,
                  current_user: current_user

    @print_date = Date.today.strftime("%d-%m-%Y")

    # Use the specified template or the default one if none given
    if params[:template].present?
      @template = Template.find params[:template]
    else
      @template = Template.where(target:'book_fine_receipt').where(active:'true').take
    end
    if @template
      @template.placeholders = {
        receipt_date: @print_date,
        receipt_no: @invoice.id,
        student_name: @student.name,
        student_grade: @student.current_grade_section.name,
        student_no: @student.current_roster_no,
        receipt_amount: helpers.number_to_currency(@total_idr_amount.to_f.round(-2), {unit:'Rp', precision:0}),
        receipt_amount_in_words: @total_idr_amount.to_f.round(-2).to_words.split.map(&:capitalize).join(' '),
        academic_year: @academic_year.name,
        received_by: @invoice.received_by,
        paid_by: @invoice.paid_by
      }
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf:         "Receipt #{('-'+@student.name if @student.present?)}",
               disposition: 'inline',
               template:    'book_fines/payment.pdf.slim',
               layout:      'pdf.html',
               page_height: '5.5in',
               page_width:  '8.5in',
               show_as_html: params.key?('debug')
      end
    end
  end

  # DELETE /book_fines/1
  # DELETE /book_fines/1.json
  def destroy
    authorize! :manage, BookFine
    @book_fine.destroy
    respond_to do |format|
      format.html { redirect_to book_fines_url, notice: 'Book fine was successfully destroyed.' }
      format.json { head :no_content }
      format.js { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_fine
      @book_fine = BookFine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_fine_params
      params.require(:book_fine).permit(:book_copy_id, :old_condition_id, :new_condition_id, :fine, :percentage, :currency, :academic_year_id, :student_id, :status)
    end

    def helpers
      ActionController::Base.helpers
    end
end
