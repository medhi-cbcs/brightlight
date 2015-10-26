class BookTitlesController < ApplicationController
  before_action :set_book_title, only: [:show, :edit, :update, :destroy]

  # GET /book_titles
  # GET /book_titles.json
  def index
    @book_titles = BookTitle.paginate(page: params[:page], per_page: 20)
  end

  # GET /book_titles/1
  # GET /book_titles/1.json
  def show
  end

  # GET /book_titles/new
  def new
    @book_title = BookTitle.new

    unless params[:edition].blank?
      edition = BookEdition.find params[:edition]
      @book_title.book_editions << edition
      @book_title.title = edition.title
      @book_title.authors = edition.authors
      @book_title.publisher = edition.publisher
      @book_title.image_url = edition.small_thumbnail
    end

    2.times { @book_title.book_editions.build }
  end

  # GET /book_titles/1/edit
  def edit
  end

  # POST /book_titles
  # POST /book_titles.json
  def create
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
      format.html { redirect_to book_titles_url, notice: 'Book title was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_title
      @book_title = BookTitle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_title_params
      params.require(:book_title).permit(:title, :authors, :publisher, :image_url)
    end
end
