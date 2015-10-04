require 'isbndb_client/api.rb'

class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /search_isbn
  def search_isbn
    @book = Book.new

    isbn = params[:isbn]

    # First try to find the ISBN in Google Books
    books = GoogleBooks::API.search("isbn:#{isbn}")
    unless books.total_results == 0
      book = books.first
      @book.title = book.title
      @book.description = book.description
      @book.authors = book.authors.join(', ')
      @book.publisher = book.publisher
      @book.isbn13 = book.isbn
      @book.isbn10 = book.isbn_10
      @book.page_count = book.page_count
      @book.small_thumbnail = book.covers[:small]
      @book.thumbnail = book.covers[:thumbnail]
      @book.published_date = book.published_date 

      respond_to do |format|
        if @book.save
          format.html { redirect_to @book, notice: 'Book was successfully created.' }
          format.json { render :show, status: :created, location: @book }
        else
          format.html { render :new }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end

    else
      # # Not found in Google Books, try the ISBNdb.com
      # results = ISBNdb::Query.find_book_by_isbn(isbn)
      # unless results.count == 0
      #   book = results.first
      #   @book.title = book.title
      #   @book.description = book.description
      #   @book.authors = book.authors_text
      #   @book.publisher = book.publisher_text['__content__']
      #   @book.isbn13 = book.isbn
      #   @book.isbn10 = book.isbn10
      #   @book.page_count = book.page_count
      #   @book.published_date = book.published_date 

      result = ISBNDBClient::API.find(isbn)
      puts result
      unless result.nil?
        book = result
        @book.title = book.title
        @book.description = book.description
        @book.authors = book.authors.map {|x| x['name']}.join(', ')
        @book.publisher = book.publisher
        @book.isbn13 = book.isbn
        @book.isbn10 = book.isbn10
        @book.page_count = book.page_count
        @book.published_date = book.published_date 

        respond_to do |format|
          if @book.save
            format.html { redirect_to @book, notice: 'Book was successfully created.' }
            format.json { render :show, status: :created, location: @book }
          else
            format.html { render :new }
            format.json { render json: @book.errors, status: :unprocessable_entity }
          end
        end
      
      else
        respond_to do |format|
          format.html { redirect_to new_book_path, alert: "Could not find book with ISBN #{isbn}" }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end

      end
    end
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:google_book_id, :isbndb_id, :title, :subtitle, :authors, :publisher, :published_date, :description, :isbn10, :isbn13, :page_count, :small_thumbnail, :thumbnail, :language, :edition_info, :tags, :subjects)
    end
end
