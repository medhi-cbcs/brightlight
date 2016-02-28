class LoanFormsController < ApplicationController
  before_action :set_loan_form, only: [:show, :edit, :update, :destroy]

  # GET /loan_forms
  # GET /loan_forms.json
  def index
    @loan_forms = LoanForm.all
  end

  # GET /loan_forms/1
  # GET /loan_forms/1.json
  def show
  end

  # GET /loan_forms/new
  def new
    @loan_form = LoanForm.new
  end

  # GET /loan_forms/1/edit
  def edit
  end

  # POST /loan_forms
  # POST /loan_forms.json
  def create
    @loan_form = LoanForm.new(loan_form_params)

    respond_to do |format|
      if @loan_form.save
        format.html { redirect_to @loan_form, notice: 'Loan form was successfully created.' }
        format.json { render :show, status: :created, location: @loan_form }
      else
        format.html { render :new }
        format.json { render json: @loan_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loan_forms/1
  # PATCH/PUT /loan_forms/1.json
  def update
    respond_to do |format|
      if @loan_form.update(loan_form_params)
        format.html { redirect_to @loan_form, notice: 'Loan form was successfully updated.' }
        format.json { render :show, status: :ok, location: @loan_form }
      else
        format.html { render :edit }
        format.json { render json: @loan_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loan_forms/1
  # DELETE /loan_forms/1.json
  def destroy
    @loan_form.destroy
    respond_to do |format|
      format.html { redirect_to loan_forms_url, notice: 'Loan form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_form
      @loan_form = LoanForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_form_params
      params[:loan_form]
    end
end
