class BookCategoriesController < ApplicationController
  before_action :set_book_category, only: [:show, :edit, :update, :destroy]

  # GET /book_categories
  # GET /book_categories.json
  def index
    @book_categories = BookCategory.all
  end

  # GET /book_categories/1
  # GET /book_categories/1.json
  def show
  end

  # GET /book_categories/new
  def new
    @book_category = BookCategory.new
  end

  # GET /book_categories/1/edit
  def edit
  end

  # POST /book_categories
  # POST /book_categories.json
  def create
    @book_category = BookCategory.new(book_category_params)

    respond_to do |format|
      if @book_category.save
        format.html { redirect_to @book_category, notice: 'Book category was successfully created.' }
        format.json { render :show, status: :created, location: @book_category }
      else
        format.html { render :new }
        format.json { render json: @book_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_categories/1
  # PATCH/PUT /book_categories/1.json
  def update
    respond_to do |format|
      if @book_category.update(book_category_params)
        format.html { redirect_to @book_category, notice: 'Book category was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_category }
      else
        format.html { render :edit }
        format.json { render json: @book_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_categories/1
  # DELETE /book_categories/1.json
  def destroy
    @book_category.destroy
    respond_to do |format|
      format.html { redirect_to book_categories_url, notice: 'Book category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_category
      @book_category = BookCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_category_params
      params.require(:book_category).permit(:code, :name)
    end
end
