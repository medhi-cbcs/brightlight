require 'isbndb_client/api.rb'

class BookTitlesController < ApplicationController
  before_action :set_book_title, only: [:show, :edit, :update, :destroy, :editions, :add_existing_editions]

  # GET /book_titles
  # GET /book_titles.json
  def index
    if params[:v] == 'list'
      items_per_page = 20
      @view_style = :list
      session[:view_style] = 'list'
    else
      items_per_page = 10
      @view_style = :block
      session[:view_style] = ''
    end
    
    respond_to do |format|
      format.html { 
        if params[:search]
          @book_titles = BookTitle.search_query(params[:search]).paginate(page: params[:page], per_page: items_per_page)
        else
          @book_titles = BookTitle.paginate(page: params[:page], per_page: items_per_page)
        end
      }
      format.json { 
        search = params[:term] || ""
        @book_titles = BookTitle.where('title LIKE ?', "%#{search}%").paginate(page: params[:page], per_page:40)
        # if params[:callback]
        #   render json: @book_titles, callback: params[:callback]
        # else
        #   render json: @book_titles
        # end
      }
    end

  end

  # GET /book_titles/1
  # GET /book_titles/1.json
  def show
  end

  # GET /book_titles/new
  def new
    @book_title = BookTitle.new

    unless params[:edition].blank?
      @edition = BookEdition.find params[:edition]
      @book_title.title = @edition.title
      @book_title.authors = @edition.authors
      @book_title.publisher = @edition.publisher
      @book_title.image_url = @edition.small_thumbnail
    else
      @edition = @book_title.book_editions.build
    end
  end

  # GET /book_titles/1/edit
  def edit
  end

  def editions
    @filterrific = initialize_filterrific(
      BookEdition,
      params[:filterrific],
      select_options: {
        sorted_by: BookEdition.options_for_sorted_by
      }
    ) or return

    @editions = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end

    # Recover from invalid param sets, e.g., when a filter refers to the
    # database id of a record that doesn’t exist any more.
    # In this case we reset filterrific and discard all filter params.
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return

  end

def add_existing_editions
  params[:add].map {|id,on| BookEdition.find(id)}.each do |edition|
    @book_title.book_editions << edition
  end
  redirect_to @book_title, notice: 'Book editions successfully added'
end

  # POST /book_titles
  # POST /book_titles.json
  def create
    @book_title = BookTitle.new(book_title_params)    

    respond_to do |format|
      if @book_title.save
        # if params[:edition].present?
        #   @book_edition = BookEdition.find(params[:edition])
        #   @book_edition.book_title_id = @book_title.id
        #   @book_edition.save
        # end
        format.html { redirect_to @book_title, notice: 'Book title was successfully created.' }
        format.json { render :show, status: :created, location: @book_title }
      else
        format.html { render :new }
        format.json { render json: @book_title.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_titles/1
  # PATCH/PUT /book_titles/1.json
  def update
    respond_to do |format|
      if @book_title.update(book_title_params)
        format.html { redirect_to @book_title, notice: 'Book title was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_title }
      else
        format.html { render :edit }
        format.json { render json: @book_title.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_titles/1
  # DELETE /book_titles/1.json
  def destroy
    @book_title.destroy
    respond_to do |format|
      format.html { redirect_to book_titles_url, notice: 'Book title was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # POST /search_isbn
  def search_isbn
    @edition = BookEdition.new
    isbn = params[:isbn]

    # First try to find the ISBN in Google Books
    books = GoogleBooks::API.search("isbn:#{isbn}")
    unless books.total_results == 0
      book = books.first
      @edition.title = book.title
      @edition.description = book.description
      @edition.authors = book.authors.join(', ')
      @edition.publisher = book.publisher
      @edition.isbn13 = book.isbn
      @edition.isbn10 = book.isbn_10
      @edition.page_count = book.page_count
      @edition.small_thumbnail = book.covers[:small]
      @edition.thumbnail = book.covers[:thumbnail]
      @edition.published_date = book.published_date 

      # Create a BookTitle with this edition
      @book_title = BookTitle.new(
        title: @edition.title,
        authors: @edition.authors, 
        publisher: @edition.publisher,
        image_url: @edition.small_thumbnail)

    else
      result = ISBNDBClient::API.find(isbn)
      puts result
      unless result.nil?
        book = result
        @edition.title = book.title
        @edition.description = book.description
        @edition.authors = book.authors.map {|x| x['name']}.join(', ')
        @edition.publisher = book.publisher
        @edition.isbn13 = book.isbn
        @edition.isbn10 = book.isbn10
        @edition.page_count = book.page_count
        @edition.published_date = book.published_date 

        # Create a BookTitle with this edition
        @book_title = BookTitle.new(
          title: @edition.title,
          authors: @edition.authors, 
          publisher: @edition.publisher)
      end
    end
    @book_title.book_editions.build @edition.attributes

    render new_book_title_path
  end
  
  rescue_from ISBNDBClient::API::Error, :with => :book_not_found

  def book_not_found(exception)
    flash[:alert] = exception
    render :new
  end
  
  # POST /book_titles/delete
  def delete
    if params[:merge]
      @book_titles = params[:merge].map {|id,on| BookTitle.find(id)}
      @book_titles.each do |book_title|
        book_title.destroy
        # TODO: check dependencies on COURSE_TEXTS table
      end
      redirect_to book_titles_path, notice: 'Book titles were successfully deleted.'
    else
      redirect_to book_titles_path
    end
  end

  # POST /book_titles/edit_merge
  def edit_merge
    if params[:merge]
      @book_titles = params[:merge].map {|id,on| BookTitle.find(id)}
      if @book_titles.count > 1
        @book_title = BookTitle.new
      else
        flash[:warning] = 'Merge can only work with 2 or more selection.'
        redirect_to :back
      end
    else
      redirect_to book_titles_path
    end
  end

  # POST /book_titles/merge
  def merge
    @book_title = BookTitle.new(book_title_params) 
    @book_titles = params[:merge].map {|id,on| BookTitle.find(id)}
    
    if @book_title.save
      @book_titles.each do |title|
        title.book_editions.each do |edition|
          edition.book_title_id = @book_title.id
          edition.save
        end
        title.destroy
        # TODO: check dependencies on COURSE_TEXTS table
      end
      redirect_to @book_title, notice: 'Book titles were successfully merged.'
    else
      render :edit_merge
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_title
      @book_title = BookTitle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_title_params
      params.require(:book_title).permit(:title, :authors, :publisher, :image_url,
                                          {book_editions_attributes: [:id, :google_book_id, :isbndb_id, :title, :subtitle, :authors, :publisher, :published_date,
                                                                      :description, :isbn10, :isbn13, :page_count, :small_thumbnail, :thumbnail, 
                                                                      :language, :edition_info, :tags, :subjects, :book_title_id]})
    end
end
