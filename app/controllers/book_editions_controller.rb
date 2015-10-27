require 'isbndb_client/api.rb'

class BookEditionsController < ApplicationController
  before_action :set_book_edition, only: [:show, :edit, :update, :destroy]

  # GET /book_editions
  # GET /book_editions.json
  def index
    if params[:v] == 'list'
      items_per_page = 20
      @view_style = :list
    else
      items_per_page = 10
      @view_style = :block
    end
    @book_editions = BookEdition.paginate(page: params[:page], per_page: items_per_page)
  end

  # GET /book_editions/1
  # GET /book_editions/1.json
  def show
  end

  # GET /book_editions/new
  def new
    @book_edition = BookEdition.new
  end

  # GET /book_editions/1/edit
  def edit
  end

  # POST /search_isbn
  def search_isbn
    @book_edition = BookEdition.new

    isbn = params[:isbn]

    # First try to find the ISBN in Google Books
    books = GoogleBooks::API.search("isbn:#{isbn}")
    unless books.total_results == 0
      book = books.first
      @book_edition.title = book.title
      @book_edition.description = book.description
      @book_edition.authors = book.authors.join(', ')
      @book_edition.publisher = book.publisher
      @book_edition.isbn13 = book.isbn
      @book_edition.isbn10 = book.isbn_10
      @book_edition.page_count = book.page_count
      @book_edition.small_thumbnail = book.covers[:small]
      @book_edition.thumbnail = book.covers[:thumbnail]
      @book_edition.published_date = book.published_date 

      respond_to do |format|
        if @book_edition.save
          format.html { redirect_to @book_edition, notice: 'Book was successfully created.' }
          format.json { render :show, status: :created, location: @book_edition }
        else
          format.html { render :new }
          format.json { render json: @book_edition.errors, status: :unprocessable_entity }
        end
      end

    else
      # # Not found in Google Books, try the ISBNdb.com
      # results = ISBNdb::Query.find_book_by_isbn(isbn)
      # unless results.count == 0
      #   book = results.first
      #   @book_edition.title = book.title
      #   @book_edition.description = book.description
      #   @book_edition.authors = book.authors_text
      #   @book_edition.publisher = book.publisher_text['__content__']
      #   @book_edition.isbn13 = book.isbn
      #   @book_edition.isbn10 = book.isbn10
      #   @book_edition.page_count = book.page_count
      #   @book_edition.published_date = book.published_date 

      result = ISBNDBClient::API.find(isbn)
      puts result
      unless result.nil?
        book = result
        @book_edition.title = book.title
        @book_edition.description = book.description
        @book_edition.authors = book.authors.map {|x| x['name']}.join(', ')
        @book_edition.publisher = book.publisher
        @book_edition.isbn13 = book.isbn
        @book_edition.isbn10 = book.isbn10
        @book_edition.page_count = book.page_count
        @book_edition.published_date = book.published_date 

        respond_to do |format|
          if @book_edition.save
            format.html { redirect_to @book_edition, notice: 'Book was successfully created.' }
            format.json { render :show, status: :created, location: @book_edition }
          else
            format.html { render :new }
            format.json { render json: @book_edition.errors, status: :unprocessable_entity }
          end
        end
      
      else
        respond_to do |format|
          format.html { redirect_to new_book_path, alert: "Could not find book with ISBN #{isbn}" }
          format.json { render json: @book_edition.errors, status: :unprocessable_entity }
        end

      end
    end
  end

  rescue_from ISBNDBClient::API::Error, :with => :book_not_found

  def book_not_found(exception)
    flash[:alert] = exception
    render :new
  end

  # POST /book_editions
  # POST /book_editions.json
  def create
    @book_edition = BookEdition.new(book_edition_params)

    respond_to do |format|
      if @book_edition.save
        format.html { redirect_to @book_edition, notice: 'Book edition was successfully created.' }
        format.json { render :show, status: :created, location: @book_edition }
      else
        format.html { render :new }
        format.json { render json: @book_edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_editions/1
  # PATCH/PUT /book_editions/1.json
  def update
    respond_to do |format|
      if @book_edition.update(book_edition_params)
        format.html { redirect_to @book_edition, notice: 'Book edition was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_edition }
      else
        format.html { render :edit }
        format.json { render json: @book_edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_editions/1
  # DELETE /book_editions/1.json
  def destroy
    @book_edition.destroy
    respond_to do |format|
      format.html { redirect_to book_editions_url, notice: 'Book edition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_edition
      @book_edition = BookEdition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_edition_params
      params.require(:book_edition).permit(:google_book_id, :isbndb_id, :title, :subtitle, :authors, :publisher, :published_date, :description, :isbn10, :isbn13, :page_count, :small_thumbnail, :thumbnail, :language, :edition_info, :tags, :subjects)
    end
end
