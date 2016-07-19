class BookConditionsController < ApplicationController
  before_action :set_book_condition, only: [:show, :edit, :update, :destroy]

  # GET /book_conditions
  # GET /book_conditions.json
  def index
    authorize! :view, BookCondition
    @book_conditions = BookCondition.all
  end

  # GET /book_conditions/1
  # GET /book_conditions/1.json
  def show
    authorize! :view, BookCondition
  end

  # GET /book_conditions/new
  def new
    authorize! :manage, BookCondition
    @book_condition = BookCondition.new
  end

  # GET /book_conditions/1/edit
  def edit
    authorize! :manage, BookCondition
  end

  # POST /book_conditions
  # POST /book_conditions.json
  def create
    authorize! :manage, BookCondition
    @book_condition = BookCondition.new(book_condition_params)

    respond_to do |format|
      if @book_condition.save
        # All of these form and url acrobats because we use slugs for BookCondition, and one of the value is 'new'. DUH....
        format.html { redirect_to book_condition_path(id:@book_condition.id), notice: 'Book condition was successfully created.' }
        format.json { render :show, status: :created, location: @book_condition }
      else
        format.html { render :new }
        format.json { render json: @book_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_conditions/1
  # PATCH/PUT /book_conditions/1.json
  def update
    authorize! :manage, BookCondition
    respond_to do |format|
      if @book_condition.update(book_condition_params)
        # All of these form and url acrobats because we use slugs for BookCondition, and one of the value is 'new'. DUH....
        format.html { redirect_to book_condition_path(id:@book_condition.id), notice: 'Book condition was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_condition }
      else
        format.html { render :edit }
        format.json { render json: @book_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_conditions/1
  # DELETE /book_conditions/1.json
  def destroy
    authorize! :manage, BookCondition
    @book_condition.destroy
    respond_to do |format|
      format.html { redirect_to book_conditions_url, notice: 'Book condition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_condition
      @book_condition = BookCondition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_condition_params
      params.require(:book_condition).permit(:code, :color, :order_no, :description)
    end
end
