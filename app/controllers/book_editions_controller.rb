class BookEditionsController < ApplicationController
  before_action :set_book_edition, only: [:show, :edit, :update, :destroy, :update_metadata]

  # GET /book_editions
  # GET /book_editions.json
  def index
    authorize! :read, BookEdition
    if params[:v] == 'list'
      items_per_page = 30
      @view_style = :list
      session[:view_style] = 'list'
    else
      items_per_page = 20
      @view_style = :block
      session[:view_style] = ''
    end
    
    @book_editions = BookEdition.with_number_of_copies
     
    respond_to do |format|      
      format.html { 
        @book_editions = @book_editions.search_query(params[:search]) if params[:search] 
        @book_editions = @book_editions.order("#{sort_column} #{sort_direction}")
                          .paginate(page: params[:page], per_page: items_per_page)
      }
      format.json { @book_editions = @book_editions.search_query(params[:term]) if params[:term] } 
    end
    
  end

  # GET /book_editions/summary
  # GET /book_editions/summary.json
  def summary
    authorize! :read, BookEdition
    @book_editions = BookEdition.all.order(:title)    
    if params[:condition] && params[:condition] != 'all' 
      @condition = BookCondition.find_by_code(params[:condition])
    end 
    respond_to do |format|
      format.html { @book_editions = @book_editions.paginate(page: params[:page], per_page: 100) }
      format.xls 
    end
  end 
  
  # GET /book_editions/1
  # GET /book_editions/1.json
  def show
    authorize! :read, @book_edition
  end

  # GET /book_editions/new
  def new
    @book_edition = BookEdition.new
  end

  # GET /book_editions/1/edit
  def edit
    authorize! :update, @book_edition
  end

  # POST /book_editions
  # POST /book_editions.json
  def create
    authorize! :manage, BookEdition
    @book_edition = BookEdition.new(book_edition_params)

    respond_to do |format|
      if @book_edition.save
        nested_form = book_edition_params[:book_copies_attributes].present?
        format.html { redirect_to nested_form ? book_edition_book_copies_path(@book_edition) : @book_edition, notice: 'Book edition was successfully created.' }
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
    authorize! :update, @book_edition
    respond_to do |format|
      if @book_edition.update(book_edition_params)
        if book_edition_params[:small_thumbnail].present? and @book_edition.book_title.image_url.blank?
          @book_edition.book_title.update_attribute :image_url, book_edition_params[:small_thumbnail]
        end
        nested_form = book_edition_params[:book_copies_attributes].present?
        format.html {
          if nested_form
            redirect_to book_edition_book_copies_path(@book_edition)
          else
            # This part handles the regular request from GET /book_editions/1/edit
            redirect_to @book_edition, notice: 'Book edition was successfully updated.'
            
          end
        }
        format.json { render :show, status: :ok, location: @book_edition }
        if @book_edition.subjects.present?
          @book_edition.book_title.update_attribute :subject_id,@book_edition.subjects
        end
      else
        format.html { render :edit }
        format.json { render json: @book_edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_editions/1
  # DELETE /book_editions/1.json
  def destroy
    authorize! :destroy, @book_edition
    @book_edition.destroy
    respond_to do |format|
      format.html { redirect_to book_editions_url, notice: 'Book edition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /book_editions/1/update_metadata
  def update_metadata
    authorize! :update, @book_edition
    begin
      @book_edition = @book_edition.update_metadata
    rescue
      @error = "ISBN No #{@book_edition.isbn} did not match any book results"
    end
    respond_to do |format|
      format.html do
        if @error.present?
          redirect_to @book_edition, alert: @error
        else
          render :edit
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_edition
      @book_edition = BookEdition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_edition_params
      params.require(:book_edition).permit(
        :google_book_id, :isbndb_id, :title, :subtitle, :authors, :publisher, :published_date,
        :description, :isbn10, :isbn13, :page_count, :small_thumbnail, :thumbnail,
        :language, :edition_info, :tags, :subjects, :book_title_id, :refno, :price, :currency, :legacy_code,
        {:book_copies_attributes => [:id, :book_edition_id, :book_condition_id, :status_id, :barcode, :copy_no, :book_label_id, :notes, :_destroy]}
      )
    end

    def sortable_columns 
      [:title, :authors, :publisher, :isbn13, :refno]
    end 
    
end
