class AcademicYearsController < ApplicationController
  before_action :set_academic_year, only: [:show, :edit, :update, :destroy]

  # GET /academic_years
  # GET /academic_years.json
  def index
    @academic_years = AcademicYear.all
  end

  # GET /academic_years/1
  # GET /academic_years/1.json
  def show
  end

  # GET /academic_years/new
  def new
    @academic_year = AcademicYear.new
    2.times { @academic_year.academic_terms.build }
  end

  # GET /academic_years/1/edit
  def edit
    if @academic_year.academic_terms.blank?
      2.times { @academic_year.academic_terms.build }
    end
  end

  # POST /academic_years
  # POST /academic_years.json
  def create
    puts "DEBUG CREATE"
    puts params
    @academic_year = AcademicYear.new(academic_year_params)

    respond_to do |format|
      if @academic_year.save
        format.html { redirect_to @academic_year, notice: 'Academic year was successfully created.' }
        format.json { render :show, status: :created, location: @academic_year }
      else
        format.html { render :new }
        format.json { render json: @academic_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /academic_years/1
  # PATCH/PUT /academic_years/1.json
  def update
    puts "DEBUG UPDATE"
    puts params
    respond_to do |format|
      if @academic_year.update(academic_year_params)
        format.html { redirect_to @academic_year, notice: 'Academic year was successfully updated.' }
        format.json { render :show, status: :ok, location: @academic_year }
      else
        format.html { render :edit }
        format.json { render json: @academic_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /academic_years/1
  # DELETE /academic_years/1.json
  def destroy
    @academic_year.destroy
    respond_to do |format|
      format.html { redirect_to academic_years_url, notice: 'Academic year was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_academic_year
      @academic_year = AcademicYear.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def academic_year_params
      params.require(:academic_year).permit(:name, :start_date, :end_date, 
                                           {:academic_terms_attributes => [:academic_term_id, :name, :start_date, :end_date]})
    end
end
