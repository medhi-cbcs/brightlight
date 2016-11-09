class GuardiansController < ApplicationController
  before_action :set_guardian, only: [:show, :edit, :update, :destroy]

  # GET /guardians
  # GET /guardians.json
  def index
    authorize! :read, Guardian
    items_per_page = 30
    if params[:search]
      @guardians = Guardian.where('UPPER(name) LIKE ?', "%#{params[:search].upcase}%").includes(:family)
    else
      @guardians = Guardian.includes(:family)
    end
    @guardians = @guardians.paginate(page: params[:page], per_page: items_per_page)
  end

  # GET /guardians/1
  # GET /guardians/1.json
  def show
    authorize! :read, Guardian
  end

  # GET /guardians/new
  def new
    authorize! :manage, Guardian
    @guardian = Guardian.new
  end

  # GET /guardians/1/edit
  def edit
    authorize! :update, Guardian
  end

  # POST /guardians
  # POST /guardians.json
  def create
    authorize! :manage, Guardian
    @guardian = Guardian.new(guardian_params)

    respond_to do |format|
      if @guardian.save
        format.html { redirect_to @guardian, notice: 'Guardian was successfully created.' }
        format.json { render :show, status: :created, location: @guardian }
      else
        format.html { render :new }
        format.json { render json: @guardian.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guardians/1
  # PATCH/PUT /guardians/1.json
  def update
    authorize! :update, Guardian
    respond_to do |format|
      if @guardian.update(guardian_params)
        format.html { redirect_to @guardian, notice: 'Guardian was successfully updated.' }
        format.json { render :show, status: :ok, location: @guardian }
      else
        format.html { render :edit }
        format.json { render json: @guardian.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guardians/1
  # DELETE /guardians/1.json
  def destroy
    authorize! :destroy, Guardian
    @guardian.destroy
    respond_to do |format|
      format.html { redirect_to guardians_url, notice: 'Guardian was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guardian
      @guardian = Guardian.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guardian_params
      params.require(:guardian).permit(:name, :first_name, :last_name, :mobile_phone, :home_phone, :office_phone, :other_phone, :address_line1, :address_line2, :city, :state, :postal_code, :country, :family_no)
    end
end
