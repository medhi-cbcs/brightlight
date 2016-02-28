class BookFinesController < ApplicationController
  before_action :set_book_fine, only: [:show, :edit, :update, :destroy]

  # GET /book_fines
  # GET /book_fines.json
  def index
    @book_fines = BookFine.all
  end

  # GET /book_fines/1
  # GET /book_fines/1.json
  def show
  end

  # GET /book_fines/new
  def new
    @book_fine = BookFine.new
  end

  # GET /book_fines/1/edit
  def edit
  end

  # POST /book_fines
  # POST /book_fines.json
  def create
    @book_fine = BookFine.new(book_fine_params)

    respond_to do |format|
      if @book_fine.save
        format.html { redirect_to @book_fine, notice: 'Book fine was successfully created.' }
        format.json { render :show, status: :created, location: @book_fine }
      else
        format.html { render :new }
        format.json { render json: @book_fine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_fines/1
  # PATCH/PUT /book_fines/1.json
  def update
    respond_to do |format|
      if @book_fine.update(book_fine_params)
        format.html { redirect_to @book_fine, notice: 'Book fine was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_fine }
      else
        format.html { render :edit }
        format.json { render json: @book_fine.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /book_fines/calculate
  def calculate

  end

  # DELETE /book_fines/1
  # DELETE /book_fines/1.json
  def destroy
    @book_fine.destroy
    respond_to do |format|
      format.html { redirect_to book_fines_url, notice: 'Book fine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_fine
      @book_fine = BookFine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_fine_params
      params.require(:book_fine).permit(:book_copy_id, :old_condition_id, :new_condition_id, :fine, :academic_year_id, :student_id, :status)
    end
end
