class Admin::AcademicTermsController < ApplicationController
  before_action :set_academic_term, only: [:show, :edit, :update, :destroy]

  # GET /academic_terms
  # GET /academic_terms.json
  def index
    @academic_terms = AcademicTerm.all
  end

  # GET /academic_terms/1
  # GET /academic_terms/1.json
  def show
  end

  # GET /academic_terms/new
  def new
    @academic_term = AcademicTerm.new
  end

  # GET /academic_terms/1/edit
  def edit
  end

  # POST /academic_terms
  # POST /academic_terms.json
  def create
    @academic_term = AcademicTerm.new(academic_term_params)

    respond_to do |format|
      if @academic_term.save
        format.html { redirect_to [:admin, @academic_term], notice: 'Academic term was successfully created.' }
        format.json { render :show, status: :created, location:[:admin, @academic_term] }
      else
        format.html { render :new }
        format.json { render json: @academic_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /academic_terms/1
  # PATCH/PUT /academic_terms/1.json
  def update
    respond_to do |format|
      if @academic_term.update(academic_term_params)
        format.html { redirect_to [:admin, @academic_term], notice: 'Academic term was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @academic_term] }
      else
        format.html { render :edit }
        format.json { render json: @academic_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /academic_terms/1
  # DELETE /academic_terms/1.json
  def destroy
    @academic_term.destroy
    respond_to do |format|
      format.html { redirect_to admin_academic_terms_url, notice: 'Academic term was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_academic_term
      @academic_term = AcademicTerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def academic_term_params
      params.require(:academic_term).permit(:name, :start_date, :end_date, :academic_year_id)
    end
end
