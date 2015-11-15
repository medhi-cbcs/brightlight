class BookTitlesController < ApplicationController
  before_action :set_book_title, only: [:show, :edit, :update, :destroy]

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
          @book_titles = BookTitle.where('title LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: items_per_page)
        else
          @book_titles = BookTitle.paginate(page: params[:page], per_page: items_per_page)
        end      
      }
      format.json { 
        search = params[:search] || ""
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
    end
  end

  # GET /book_titles/1/edit
  def edit
  end

  # POST /book_titles
  # POST /book_titles.json
  def create
    @book_title = BookTitle.new(book_title_params)    
    @book_edition = BookEdition.find(params[:edition]) if params[:edition]

    respond_to do |format|
      if @book_title.save
        if params[:edition]
          @book_edition.book_title_id = @book_title.id
          @book_edition.save
        end
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
      @book_title = BookTitle.new
    else
      redirect_to book_titles_path
    end
  end

  # POST /book_titles/merge
  def merge
    @book_title = BookTitle.new(book_title_params) 
    @book_titles = params[:merge].map {|id,on| BookTitle.find(id)}
    @book_titles.each do |title|
      @book_title.book_editions << title.book_editions
      title.destroy
      # TODO: check dependencies on COURSE_TEXTS table
    end
    if @book_title.save
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
                                          {:book_editions_attributes => [:id]})
    end
end
