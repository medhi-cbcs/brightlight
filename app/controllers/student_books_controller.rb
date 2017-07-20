class StudentBooksController < ApplicationController
  before_action :set_student_book, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json, :js

  # GET /student_books
  # GET /student_books.json
  def index
    authorize! :read, StudentBook
    items_per_page = 25
    @grade_levels = GradeLevel.all.order(:id)
    @grade_level_ids = @grade_levels.collect(&:id)
    @grade_sections = GradeSection.all.order(:grade_level_id, :id)
    @grade_sections_ids = @grade_sections.collect(&:id)
    if params[:s].present?
      @grade_section = @grade_sections.where(id:params[:s]).first
      @grade_level = @grade_section.grade_level
    end

    @year_id = params[:year] || AcademicYear.current_id
    @academic_year = AcademicYear.find @year_id
    textbook_category_id = BookCategory.find_by_code('TB').id

    if params[:student_id].present?
      @student = Student.where(id:params[:student_id]).take
      gss = @student.grade_sections_students.where(academic_year_id: @year_id).try(:first)
      if gss.present?
        @grade_section = gss.grade_section
        @roster_no = gss.order_no
        # Notes: Because of data errors in database, we search StudentBook without student_id
        # =>     but filter it with grade_section, year and roster_no
        @student_books = StudentBook.where(grade_section:@grade_section)
                          .standard_books(@grade_section.grade_level.id, @grade_section.id, @year_id, textbook_category_id)
                          .where(roster_no:@roster_no.to_s)
                          .where(academic_year_id:@year_id)
                          .includes([:book_copy, book_copy: [:book_edition]])
      end
    elsif params[:s].present?
      @students = @grade_section.current_students
      @student_books = StudentBook.where(grade_section:@grade_section)
                        .where(academic_year_id:@year_id)
                        .standard_books(@grade_section.grade_level.id, @grade_section.id, @year_id, textbook_category_id)
                        .order('roster_no ASC, standard_books.id ASC')
                        .includes([:book_copy, book_copy: [:book_edition]])
    else
      @student_books = StudentBook.includes([:book_copy, book_copy: [:book_edition]])
                        .where(academic_year_id:@year_id)
                        .paginate(page: params[:page], per_page: items_per_page)
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf:         "StudentBooks-#{@grade_section.slug if params[:s].present?}#{('-'+@student.name if @student.present?)}",
               disposition: 'inline',
               template:    'student_books/index.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('debug')
      end
    end
  end

  # GET /student_books/1
  # GET /student_books/1.json
  def show
    authorize! :read, @student_book
    @student = @student_book.student
  end

  # GET /students/:student_id/student_books/new
  def new
    authorize! :manage, StudentBook
    @student = Student.find(params[:student_id])
    @grade_section = @student.grade_sections_students.where(academic_year:AcademicYear.current).try(:first).try(:grade_section)
    @student_book = @student.student_books.new
  end

  # GET /student_books/1/edit
  def edit
    authorize! :update, @student_book
    @student = @student_book.student
  end

  # POST /students/:student_id/student_books
  # POST /students/:student_id/student_books.json
  def create
    @student = Student.find(params[:student_id])
    @student_book = @student.student_books.new(student_book_params)
    authorize! :create, @student_book

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
    authorize! :update, @student_book
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
    authorize! :update, @student_book
    @grade_section = GradeSection.find(params[:section])
    @students = @grade_section.students
  end

  # DELETE /student_books/1
  # DELETE /student_books/1.json
  def destroy
    authorize! :destroy, @student_book
    @student = @student_book.student
    @student_book.destroy
    respond_to do |format|
      format.html { redirect_to student_student_books_path(student_id:@student.id), notice: 'Student book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /student_books/receipt_form
  def receipt_form
    authorize! :manage, StudentBook
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

  # GET /student_books/missing
  def missing
    authorize! :manage, StudentBook
    @year_id = params[:year] || AcademicYear.current_id
    @academic_year = AcademicYear.find @year_id
    @grade_level_ids = GradeLevel.all.order(:id).collect(&:id)
    @grade_sections = GradeSection.all.order(:grade_level_id, :id)
    @grade_sections_ids = @grade_sections.collect(&:id)

    @grade_section = GradeSection.where(id:params[:s]).take if params[:s].present?
    @grade_level = GradeLevel.where(id:params[:l]).take if params[:l].present?

    @textbook_category_id = BookCategory.find_by_code('TB').id
    missing = BookCondition.find_by_slug('missing')

    if @grade_section.present?
      @student_books = StudentBook
                        .standard_books(@grade_section.grade_level.id, @grade_section.id, @year_id, @textbook_category_id)
                        .where(academic_year_id: @year_id)
                        .where(end_copy_condition: missing)
                        .where(grade_section:@grade_section)
                        .order('CAST(roster_no AS int)')
      @students = Student.in_section_having_books_with_condition missing, section:@grade_section
    else
      @students = Student.having_books_with_condition missing
      @student_books = StudentBook
                        .where(academic_year_id: @year_id)
                        .where(end_copy_condition: missing)
                        .order('grade_section_id ASC' ,'CAST(roster_no AS int)')
    end

    respond_to do |format|
      format.html
      format.pdf do
        # Use the specified template or the default one if none given
        if params[:template].present?
          @template = Template.find params[:template]
        else
          @template = Template.where(target:'missing_books').where(active:'true').take
        end

        # if @template
        #   @template.placeholders = {
        #     student_name: @student.name,
        #     grade_section: @student.current_grade_section.name
        #   }
        # end

        render pdf:         "Missing_Book_List#{('-'+@grade_section.name if @grade_section.present?)}",
               disposition: 'inline',
               template:    'student_books/missing.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('screen')
      end
    end
  end

  # GET /student_books/pnnrb
  def pnnrb
    authorize! :read, @student_book
    @year_id = params[:year] || AcademicYear.current_id
    @academic_year = AcademicYear.find @year_id
    @grade_level_ids = GradeLevel.all.order(:id).collect(&:id)
    @grade_sections = GradeSection.all.order(:grade_level_id, :id)
    @grade_sections_ids = @grade_sections.collect(&:id)

    @grade_section = GradeSection.where(id:params[:s]).take if params[:s].present?
    @grade_level = GradeLevel.where(id:params[:l]).take if params[:l].present?
    @textbook_category_id = BookCategory.find_by_code('TB').id
    poor = BookCondition.find_by_slug('poor')

    if @grade_section.present?
      @student_books = StudentBook
                        .standard_books(@grade_section.grade_level.id, @grade_section.id, @year_id, @textbook_category_id)
                        .where(academic_year_id: @year_id)
                        .where("end_copy_condition_id = ? OR needs_rebinding = true", poor.id)
                        .where(grade_section:@grade_section)
                        .order(:book_edition_id, 'CAST(roster_no AS int)')

    else
      @student_books = StudentBook
                        .where(academic_year_id: @year_id)
                        .where("end_copy_condition_id = ? OR needs_rebinding = true", poor.id)
                        .order(:book_edition_id, 'CAST(roster_no AS int)')
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf:         "List of Poor Book or Needs Rebinding#{('-'+@grade_section.name if @grade_section.present?)}",
               disposition: 'inline',
               template:    'student_books/pnnrb.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('screen')
      end
    end
  end

  # POST /student_books/finalize.js
  def finalize
    authorize! :manage, StudentBook
    academic_year_id = params[:finalize_student_books_year].to_i

    respond_to do |format|
      format.js do
        grades = params[:finalize_student_books].reject {|k,v| k == "all"}.keys
        BookCopy.update_conditions_from_student_books academic_year_id, academic_year_id+1, grades
      end
    end
  end

  # GET /student_books/by_title
  def by_title
    authorize! :manage, StudentBook
    @year_id = params[:year] || AcademicYear.current_id
    @disable_edit = @year_id.to_i != AcademicYear.current_id
    @academic_year = AcademicYear.find @year_id

    if params[:s].present?
      @grade_section = GradeSection.find(params[:s])
      @grade_level = @grade_section.grade_level
                    
      all_books = StudentBook.where(academic_year_id:@year_id,grade_section: @grade_section)
      @all_titles = all_books.joins(:book_edition)
                      .group('book_edition_id, book_editions.title')
                      .select('book_edition_id as id, book_editions.title as title')
                      .order('book_editions.title')

      if params[:t].present?
        # A book title is selected, here we load only the specified book title
        @book_edition_id = params[:t]
        @title = BookEdition.find(@book_edition_id).title
        @book_titles = @all_titles.where(book_edition_id: @book_edition_id)
        @student_books = all_books.where(book_edition_id: @book_edition_id)
                          .joins(:book_edition)   
                          .order('book_editions.title')
                          .includes([:book_copy])
      else
        # No book title is selected, here we load ALL book titles for the grade_section
        @book_titles = @all_titles
        @student_books = all_books.joins(:book_edition)
                          .order('book_editions.title, CAST(roster_no as INT)')
                          .includes([:book_copy])        
      end
    end

    respond_to do |format|
      format.html do
        @grade_level_ids = GradeLevel.all.collect(&:id)
        @grade_sections = GradeSection.all.order(:grade_level_id, :id)
        @grade_sections_ids = @grade_sections.collect(&:id)
      end
      format.pdf do
        @num_titles = @book_titles.to_a.count
        render pdf:         "BookList-#{@grade_section.slug}#{('-'+@title if @title.present?)}",
               disposition: 'inline',
               template:    'student_books/by_title.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('debug')
      end
    end
  end

  # GET /student_books/by_student
  def by_student
    authorize! :manage, StudentBook
    @year_id = params[:year] || AcademicYear.current_id
    @disable_edit = @year_id.to_i != AcademicYear.current_id
    @academic_year = AcademicYear.find @year_id
    
    if params[:s].present?
      @grade_section = GradeSection.find(params[:s])
      @grade_level = @grade_section.grade_level
      @all_students = @grade_section.students_for_academic_year(@year_id)            
    end

    @textbook_category_id = BookCategory.find_by_code('TB').id

    if params[:st].present?
      # A student is selected, here we load only the specified student
      @student = Student.find params[:st]      
      @student_list = @all_students.where(student:@student)
      @next_in_list = @all_students.where(order_no: @student_list.take.try(:order_no) + 1).take
      gss = @student_list.take
      @grade_section = gss.try(:grade_section)
      @roster_no = gss.order_no
      @student_books = @student.student_books         
                          .standard_books(@grade_section.grade_level.id, @grade_section.id, @year_id, @textbook_category_id)    
                          .order('standard_books.id')
                          .includes([:book_copy])
    elsif params[:s].present?
      # No student is selected, here we load ALL for the grade_section   
      @student_list = @all_students   
      @student_books = StudentBook.where(grade_section:@grade_section)
                        .standard_books(@grade_section.grade_level.id, @grade_section.id, @year_id, @textbook_category_id)      
                        .order('roster_no ASC, standard_books.id ASC')
                        .includes([:book_copy])
    end

    respond_to do |format|
      format.html do
        @grade_level_ids = GradeLevel.all.order(:id).collect(&:id)
        @grade_sections = GradeSection.all.order(:grade_level_id, :id)
        @grade_sections_ids = @grade_sections.collect(&:id)
      end
      format.pdf do
        render pdf:         "StudentBooks-#{@grade_section.slug}#{'#'+@roster_no.to_s if @roster_no.present?}",
               disposition: 'inline',
               template:    'student_books/by_student.pdf.slim',
               layout:      'pdf.html',
               show_as_html: params.key?('debug')
      end
    end
  end

  # PUT /student_books/update_multiple
  # PUT /student_books/update_multiple.json
  def update_multiple
    authorize! :manage, StudentBook
    StudentBook.update(params[:student_books].keys, params[:student_books].values)
    @book_category = BookCategory.find_by_code 'TB'
    @current_year = AcademicYear.current_id

    params[:book_loans].each do |key, values|
      book_loan = BookLoan.where(academic_year_id:@current_year, book_copy_id:values[:book_copy_id]).take
      book_loan.update(return_date: values[:return_date],
                       user_id: values[:user_id],
                       notes: values[:notes],
                       student_no: values[:student_no])
    end

    flash[:notice] = "Book conditions updated!"
    if params[:student_form].present?
      if params[:next]
        redirect_to by_student_student_books_path(s:params[:grade_section_id],g:params[:grade_level_id],st:params[:next])
      else
        redirect_to by_student_student_books_path(s:params[:grade_section_id],g:params[:grade_level_id],st:params[:st])
      end
    else
      redirect_to by_title_student_books_path(s:params[:grade_section_id],g:params[:grade_level_id],t:params[:title])
    end
  end

  # POST /student_books/prepare.js
  def prepare
    authorize! :manage, StudentBook
    academic_year_id = params[:prepare_student_book_year].to_i
    grades = params[:prepare_student_books].reject {|k,v| k == "all"}.keys
    GradeSection.where("grade_level_id in (?)", grades).each do |section|
      section.students_for_academic_year(academic_year_id).each do |gss|
        StudentBook.initialize_from_book_receipts gss:gss, year:AcademicYear.find(academic_year_id)
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def titles
    # grade_level = params[:l]
    grade_section = params[:s]
    year = params[:year]
    all_books = StudentBook.joins(:book_edition)
                  .where(academic_year_id: year, grade_section: grade_section)
    book_titles = all_books.group('book_edition_id, book_editions.title')
                  .select('book_edition_id, book_editions.title as title')
                  .order('book_editions.title')
    respond_to do |format|
      format.json { render json: book_titles.map {|book| {id:book.book_edition_id, title:book.title}} }
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
        :initial_copy_condition_id, :end_copy_condition_id, :notes, :needs_repair,
        {book_loan_attributes: [:grade_section_id, :grade_level_id, :academic_year_id, :book_copy_id, :book_edition_id,
          :book_title_id, :out_date, :return_date, :student_id, :book_category, :student_no, :roster_no,
          :barcode, :grade_section_code, :grade_subject_code, :notes, :prev_academic_year_id, :user_id]})
    end
end
