class StudentBooksController < ApplicationController
  before_action :set_student_book, only: [:show, :edit, :update, :destroy]

  # GET /student_books
  # GET /student_books.json
  def index
    items_per_page = 25
    @grade_levels = GradeLevel.all
    @grade_level_ids = @grade_levels.collect(&:id)
    @grade_sections = GradeSection.all
    @grade_sections_ids = @grade_sections.collect(&:id)
    if params[:s].present?
      @grade_section = @grade_sections.where(id:params[:s]).first
      @grade_level = @grade_section.grade_level
    end
    if params[:student_id].present?
      year_id = AcademicYear.current.id
      @student = Student.where(id:params[:student_id]).take
      gss = @student.grade_sections_students.where(academic_year_id: year_id).try(:first)
      @grade_section= gss.try(:grade_section)
      @roster_no = gss.order_no

      # Notes: Because of data errors in database, we search StudentBook without student_id
      # =>     but filter it with grade_section, year and roster_no
      @student_books = StudentBook.where(grade_section:@grade_section)
                        .where(roster_no:@roster_no.to_s)
                        .where(academic_year_id:year_id)
                        .standard_books(@grade_section.grade_level.id, year_id)
                        .order('standard_books.id')
                        .includes([:book_copy, book_copy: [:book_edition]])
    else
      @student_books = StudentBook.includes([:book_copy, book_copy: [:book_edition]]).paginate(page: params[:page], per_page: items_per_page)
    end
  end

  # GET /student_books/1
  # GET /student_books/1.json
  def show
    @student = @student_book.student
  end

  # GET /students/:student_id/student_books/new
  def new
    @student = Student.find(params[:student_id])
    @grade_section = @student.grade_sections_students.where(academic_year:AcademicYear.current).try(:first).try(:grade_section)
    @student_book = @student.student_books.new
  end

  # GET /student_books/1/edit
  def edit
    @student = @student_book.student
  end

  # POST /students/:student_id/student_books
  # POST /students/:student_id/student_books.json
  def create
    @student = Student.find(params[:student_id])
    @student_book = @student.student_books.new(student_book_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_student_books_path(@student), notice: 'Student book was successfully created.' }
        format.json { render :show, status: :created, location: @student_book }
      else
        format.html { render :new }
        format.json { render json: @student_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_books/1
  # PATCH/PUT /student_books/1.json
  def update
    respond_to do |format|
      if @student_book.update(student_book_params)
        format.html { redirect_to student_student_books_path(@student), notice: 'Student book was successfully updated.' }
        format.json { render :show, status: :ok, location: @student_book }
      else
        format.html { render :edit }
        format.json { render json: @student_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # # GET /student_books/assign
  def assign
    @grade_section = GradeSection.find(params[:section])
    @students = @grade_section.students
  end

  # # POST /grade_section/1/student_books/label
  # # POST /grade_section/1/student_books/label.json
  # def label
  #   @grade_section = GradeSection.new(params[:grade_section_id])
  #
  #   respond_to do |format|
  #     if @grade_section.save
  #       format.html { redirect_to @student_book, notice: 'Student book was successfully created.' }
  #       format.json { render :show, status: :created, location: @student_book }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @student_book.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /student_books/1
  # DELETE /student_books/1.json
  def destroy
    @student = @student_book.student
    @student_book.destroy
    respond_to do |format|
      format.html { redirect_to student_student_books_path(student_id:@student.id), notice: 'Student book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /student_books/receipt_form
  def receipt_form
    if params[:gs].present?
      @grade_section = GradeSection.find params[:gs]
      @grade_level = @grade_section.grade_level
      @book_labels = BookLabel.where(grade_section:@grade_section)
    elsif params[:l].present?
      @book_labels = BookLabel.where(id:params[:l])
      @grade_level = GradeLevel.find(@book_labels.first.grade_level_id)
      @grade_level_name = @grade_level.name
      @grade_section_name = @book_labels.first.section_name
    end

    respond_to do |format|
      format.html do
        @grade_level_ids = GradeLevel.all.collect(&:id)
        @grade_sections = GradeSection.all
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

  # GET /student_books/by_title
  def by_title
    if params[:section].present?
      @grade_section = GradeSection.find_by_slug(params[:section])
      @grade_level = @grade_section.grade_level
      @student_books = StudentBook
                        .standard_books(AcademicYear.current.id)
                        .where(grade_section:@grade_section)
                        .where(academic_year_id:AcademicYear.current.id)
                        .order(:roster_no,:book_edition_id)
    end

    respond_to do |format|
      format.html do
        @grade_level_ids = GradeLevel.all.collect(&:id)
        @grade_sections = GradeSection.all
        @grade_sections_ids = @grade_sections.collect(&:id)
      end
      format.pdf do
        render pdf:         'form.pdf',
               disposition: 'inline',
               template:    'student_books/by_title.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('debug')
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_book
      @student_book = StudentBook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_book_params
      params.require(:student_book).permit(:student_id, :book_copy_id, :academic_year_id, :course_text_id, :copy_no,
        :grade_section_id, :grade_level_id, :course_text_id, :course_id, :issue_date, :return_date,
        :initial_copy_condition_id, :end_copy_condition_id)
    end
end
