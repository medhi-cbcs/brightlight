class BookReceiptsController < ApplicationController
  before_action :set_book_receipt, only: [:show, :edit, :update, :destroy]

  # GET /book_receipts
  # GET /book_receipts.json
  def index
    authorize! :read, BookReceipt
    @academic_year = AcademicYear.where(id:params[:year]).take || AcademicYear.current

    if params[:gs].present?
      @grade_section = GradeSection.find params[:gs]
      @grade_level = @grade_section.grade_level
      @grade_level_name = @grade_level.name
      @grade_section_name = @grade_section.name
      @book_labels = BookLabel.where(grade_section:@grade_section).order(:book_no)
      @book_copies = BookReceipt.where(academic_year:@academic_year,grade_section:@grade_section)
                      .joins(:book_edition)
                      .select('book_receipts.*, book_editions.title as title')
                      .order("#{sort_column} #{sort_direction}")
                      .includes([:book_edition, :book_copy, :initial_condition])

      @number_of_students = @book_copies.maximum(:roster_no)
    end
    if params[:r].present?
      @roster_no = params[:r].to_i
      @book_labels = @book_labels.where(book_no: @roster_no)
      @book_copies = @book_copies.where(roster_no: @roster_no)
    end

    # Use the specified template or the default one if none given
    if params[:template].present?
      @template = Template.find params[:template]
    else
      @template = Template.where(target:'student_book_receipt').where(active:'true').take
    end
    if @template
      @template.placeholders = {
        grade_section: @grade_section_name,
        academic_year: @academic_year.name,
        student_name: ''
      }
    end

    respond_to do |format|
      format.html do
        @grade_level_ids = GradeLevel.all.collect(&:id)
        # We need the maximum roster_no in the book_receipts table for each grade section
        subquery = BookReceipt.select(['max(roster_no) as max_num', :grade_section_id])
                    .group(:grade_section_id)
                    .where(academic_year:@academic_year)
                    .to_sql
        @grade_sections = GradeSection.joins("INNER JOIN (#{subquery}) AS s ON grade_sections.id = s.grade_section_id")
                            .select("grade_sections.*, s.max_num")
                            .order(:grade_level_id, :id)
        @grade_sections_ids = @grade_sections.collect(&:id)
      end
      format.pdf do
        render pdf:         'receipt_form.pdf',
               disposition: 'inline',
               template:    'book_receipts/index.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('debug')
      end
    end
  end

  # GET /book_receipts/1
  # GET /book_receipts/1.json
  def show
    authorize! :read, BookReceipt
  end

  # GET /book_receipts/check.json?barcode=####&year=##
  def check
    authorize! :read, BookReceipt
    respond_to do |format|
      format.json do
        @book_copy = BookCopy.where('UPPER(barcode) = ?', params[:barcode].upcase).includes(:book_edition => :book_title).take
        if @book_copy.present?
          year = params[:year].present? ? AcademicYear.find(params[:year]) : AcademicYear.current
          receipt = BookReceipt.where(academic_year_id: year.id, book_copy:@book_copy).take
          if receipt.present?
            error_message = "#{@book_copy.barcode} was already added to #{receipt.grade_section.name} ##{receipt.roster_no}"
            render json: {errors:error_message}, status: :unprocessable_entity
          end
        else
          render json: {errors:"Invalid barcode"}, status: :unprocessable_entity
        end
      end
    end
  end

  # GET /book_receipts/new
  def new
    authorize! :create, BookReceipt
    @grade_section = GradeSection.find params[:gs] if params[:gs]
    @roster_no = params[:r].to_i if params[:r]
    @grade_sections = @grade_section.grade_level.grade_sections.order(:id)
    academic_year_id = params[:year] || AcademicYear.current_id
    @academic_year = AcademicYear.find academic_year_id
    if @grade_section.blank? or @roster_no.blank?
      redirect_to book_receipts_url, alert: 'Error: No Class or Number was selected.'
    else
      @book_receipt = BookReceipt.new
    end
  end

  # GET /book_receipts/1/edit
  def edit
    authorize! :update, @bookReceipt
  end

  # POST /book_receipts
  # POST /book_receipts.json
  def create
    authorize! :create, BookReceipt
    @book_receipt = BookReceipt.new(book_receipt_params)

    respond_to do |format|
      if @book_receipt.save
        format.html { redirect_to @book_receipt, notice: 'Book receipt was successfully created.' }
        format.json { render :show, status: :created, location: @book_receipt }
      else
        format.html { render :new }
        format.json { render json: @book_receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_receipts/1
  # PATCH/PUT /book_receipts/1.json
  def update
    authorize! :update, @bookReceipt
    respond_to do |format|
      if @book_receipt.update(book_receipt_params)
        format.html { redirect_to book_receipts_path(gs:params[:gs],r:params[:r],year:params[:year]), notice: 'Book receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_receipt }
      else
        format.html { render :edit }
        format.json { render json: @book_receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_receipts/1
  # DELETE /book_receipts/1.json
  def destroy
    authorize! :destroy, @book_receipt
    @book_receipt.destroy
    respond_to do |format|
      format.html { redirect_to book_receipts_url, notice: 'Book receipt was successfully destroyed.' }
      format.json { head :no_content }
      format.js { head :no_content }
    end
  end

  # POST /book_receipts/prepare.js
  def prepare
    authorize! :manage, BookReceipt
    academic_year_id = params[:prepare_book_receipts_year].to_i
    grades = params[:prepare_book_receipts].reject {|k,v| k == "all"}.keys

    respond_to do |format|
      format.js do
        if BookReceipt.where(academic_year_id:academic_year_id).count > 0
          @error = "Error: records are not empty for the academic year #{AcademicYear.find(academic_year_id).name}"
        else
          n = BookReceipt.initialize_book_receipts academic_year_id-1, academic_year_id, grades
          @message = "Preparation completed (#{n})."
        end
      end
    end
  end

  # GET /book_receipts/receipt_form
  def receipt_form
    authorize! :manage, BookReceipt
    if params[:gs].present?
      @grade_section = GradeSection.find params[:gs]
      @grade_level = @grade_section.grade_level
      @book_labels = BookLabel.where(grade_section:@grade_section)
      @book_copies = BookCopy.standard_books(@grade_level.id,@grade_section.id,AcademicYear.current_id)
                    .includes([:book_edition])
    end
    if params[:l].present?
      @book_labels = @book_labels.where(id:params[:l])
      @grade_level ||= GradeLevel.find(@book_labels.first.grade_level_id)
      @grade_level_name = @grade_level.name
      @grade_section_name = @book_labels.first.section_name
    end

    # Use the specified template or the default one if none given
    if params[:template].present?
      @template = Template.find params[:template]
    else
      @template = Template.where(target:'student_book_receipt').where(active:'true').take
    end
    if @template
      @template.placeholders = {
        grade_section: @grade_section_name,
        academic_year: AcademicYear.current.name,
        student_name: ''
      }
    end

    respond_to do |format|
      format.html do
        @grade_level_ids = GradeLevel.all.collect(&:id)
        @grade_sections = GradeSection.all.order(:grade_level_id, :id)
        @grade_sections_ids = @grade_sections.collect(&:id)
      end
      format.pdf do
        render pdf:         'form.pdf',
               disposition: 'inline',
               template:    'student_books/receipt_form.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('debug')
      end
    end
  end

  # POST /book_receipts/finalize_receipt_condition.js
  def finalize_condition
    authorize! :manage, BookReceipt
    academic_year_id = params[:receipt_condition_year].to_i
    grades = params[:finalize_condition_book_receipts].reject {|k,v| k == "all"}.keys
    BookReceipt.finalize_receipts_conditions academic_year_id, current_user.id, grades 

    respond_to :js
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_receipt
      @book_receipt = BookReceipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_receipt_params
      params.require(:book_receipt).permit(:book_copy_id, :grade_section_id, :academic_year_id, :student_id, :book_edition_id, :grade_section_id, :grade_level_id, :roster_no, :copy_no, :issue_date, :initial_condition_id, :return_condition_id, :barcode, :notes, :grade_section_code, :grade_subject_code, :course_id, :course_text_id, :active)
    end

    def sortable_columns 
      [:title, :barcode, :initial_condition_id]
    end 
end
