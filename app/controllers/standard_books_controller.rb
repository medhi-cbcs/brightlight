class StandardBooksController < ApplicationController
  before_action :set_standard_book, only: [:show, :edit, :update, :destroy]

  # GET /standard_books
  # GET /standard_books.json
  def index
    @items_per_page = 25
    @standard_books = StandardBook.all

    @standard_books = @standard_books.paginate(page: params[:page], per_page: @items_per_page) unless params[:grade].present?

    if params[:grade].present? and params[:grade].upcase != 'ALL'
      @grade_level = GradeLevel.find_by_slug params[:grade]
      @standard_books = @standard_books.where(grade_level:@grade_level)
    end

    if params[:year].present?
      @academic_year = AcademicYear.find_by_slug params[:year]
      @standard_books = @standard_books.where(academic_year:@academic_year) if params[:year].upcase != 'ALL'
    else
      @standard_books = @standard_books.where(academic_year:current_academic_year_id)
    end

    if params[:category].present? and params[:category].upcase != 'ALL'
      @category = BookCategory.find_by_code params[:category]
      @standard_books = @standard_books.where(book_category:@category)
    end
  end

  # GET /standard_books/1
  # GET /standard_books/1.json
  def show
  end

  # GET /standard_books/new
  def new
    @standard_book = StandardBook.new
  end

  # GET /standard_books/1/edit
  def edit
  end

  # POST /standard_books
  # POST /standard_books.json
  def create
    @standard_book = StandardBook.new(standard_book_params)

    respond_to do |format|
      if @standard_book.save
        format.html { redirect_to @standard_book, notice: 'Standard book was successfully created.' }
        format.json { render :show, status: :created, location: @standard_book }
      else
        format.html { render :new }
        format.json { render json: @standard_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /standard_books/1
  # PATCH/PUT /standard_books/1.json
  def update
    respond_to do |format|
      if @standard_book.update(standard_book_params)
        format.html { redirect_to @standard_book, notice: 'Standard book was successfully updated.' }
        format.json { render :show, status: :ok, location: @standard_book }
      else
        format.html { render :edit }
        format.json { render json: @standard_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /standard_books/1
  # DELETE /standard_books/1.json
  def destroy
    @standard_book.destroy
    respond_to do |format|
      format.html { redirect_to standard_books_url, notice: 'Standard book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_standard_book
      @standard_book = StandardBook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def standard_book_params
      params.require(:standard_book).permit(:book_title_id, :book_edition_id, :book_category_id, :isbn, :refno, :quantity, :grade_subject_code, :grade_name, :grade_level_id, :grade_section_id, :group, :category, :bkudid, :notes, :academic_year_id)
    end
end
