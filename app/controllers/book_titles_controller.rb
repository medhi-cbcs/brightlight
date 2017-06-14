require 'isbndb_client/api.rb'

class BookTitlesController < ApplicationController
  before_action :set_book_title, only: [:show, :edit, :update, :destroy, :editions, :add_existing_editions, :add_isbn, :update_metadata]

  # GET /book_titles
  # GET /book_titles.json
  def index
    authorize! :read, BookTitle
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
        if params[:term]
          @book_titles = BookTitle
            .search_query(params[:term])
            .includes(:book_editions)
            .paginate(page: params[:page], per_page: items_per_page)
        elsif params[:copy]
          redirect_to book_copy_path(params[:copy].upcase)
        else
          @book_titles = BookTitle
            .includes(:book_editions)
            .paginate(page: params[:page], per_page: items_per_page)
        end
      }
      format.json {
        search = params[:term] || ""
        @book_titles = BookTitle.where('title LIKE ?', "%#{search}%")
          .includes(:book_editions)
          .paginate(page: params[:page], per_page:40)
      }
    end
  end

  # GET /book_titles/1
  # GET /book_titles/1.json
  def show
    authorize! :read, BookTitle
  end

  # GET /book_titles/new
  def new
    authorize! :manage, BookTitle
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
    authorize! :update, @book_title
  end

  def editions
    authorize! :update, @book_title
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

  # POST /book_titles
  # POST /book_titles.json
  def create
    authorize! :manage, BookTitle
    @book_title = BookTitle.new(book_title_params)
    
    respond_to do |format|
      if @book_title.save
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
    authorize! :update, @book_title
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
    authorize! :destroy, @book_title
    @book_title.destroy
    respond_to do |format|
      format.html { redirect_to book_titles_url, notice: 'Book title was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def add_existing_editions
    authorize! :update, @book_title
    if params[:add]
      params[:add].map {|id,on| BookEdition.find(id)}.each do |edition|
        @book_title.book_editions << edition
      end
      redirect_to @book_title, notice: 'Book editions successfully added'
    else
      flash[:warning] = 'You must select at least one.'
      redirect_to :back
    end
  end

  def add_isbn
    isbn = params[:isbn]

    begin
      book_edition = BookEdition.searchGoogleAPI(isbn)
      book_edition = BookEdition.searchISBNDB(isbn) if book_edition.blank?

      respond_to do |format|
        if book_edition.save
          @book_title.book_editions << book_edition
          format.html { redirect_to @book_title, notice: 'Book edition was successfully added.' }
          format.json { render :show, status: :created, location: @book_edition }
        else
          format.html { redirect_to @book_title, alert: "Couldn't add edition with ISBN #{isbn}" }
          format.json { render json: @book_title.errors, status: :unprocessable_entity }
        end
      end

    rescue ISBNDBClient::API::Error
      respond_to do |format|
        format.html { redirect_to @book_title, alert: "Couldn't find edition with ISBN #{isbn}" }
        format.json { render json: @book_title.errors, status: :unprocessable_entity }
      end
    end
  end

  def search_isbn
    authorize! :manage, BookTitle
    isbn = params[:isbn]

    begin
      @edition = BookEdition.searchGoogleAPI(isbn)
      @edition = BookEdition.searchISBNDB(isbn) if @edition.blank?

      @book_title = BookTitle.new(
          title: @edition.title,
          authors: @edition.authors,
          publisher: @edition.publisher,
          image_url: @edition.small_thumbnail)
      @book_title.book_editions.build @edition.attributes

      render new_book_title_path

    rescue ISBNDBClient::API::Error
      respond_to do |format|
        format.html {
          flash[:alert] = "Couldn't find edition with ISBN #{isbn}"
          @book_title = BookTitle.new
          @edition = @book_title.book_editions.build
          render :new
        }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /book_titles/delete
  def delete
    authorize! :destroy, BookTitle
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
    authorize! :update, @book_title
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
    authorize! :update, BookTitle
    @book_title = BookTitle.new(book_title_params)
    @book_titles = params[:merge].map {|id,on| BookTitle.find(id)}

    if @book_title.save
      @book_titles.each do |title|
        title.book_editions.each do |edition|
          edition.book_title_id = @book_title.id
          edition.subjects = @book_title.subject_code
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

  # POST /book_titles/1/update_metadata
  def update_metadata
    authorize! :update, BookTitle
    respond_to do |format|
      @book_title.book_editions.each { |edition| edition.update_metadata }
      format.js
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_title
      @book_title = BookTitle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_title_params
      params.require(:book_title).permit(:title, :authors, :publisher, :image_url, :subject_id,
                                          {book_editions_attributes: [:id, :google_book_id, :isbndb_id, :title, :subtitle, :authors, :publisher, :published_date,
                                                                      :description, :isbn10, :isbn13, :refno, :legacy_code, :page_count, :small_thumbnail, :thumbnail, 
                                                                      :language, :edition_info, :tags, :subjects, :currency, :price, :book_title_id, :_destroy]
                                          }
                                        )
    end
end
