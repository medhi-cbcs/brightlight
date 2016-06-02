class CurrenciesController < ApplicationController
  before_action :set_currency, only: [:show, :edit, :update, :destroy]

  # GET /currencies
  # GET /currencies.json
  def index
    @currencies = Currency.all.order('updated_at DESC')
    @currency = Currency.new
  end

  # GET /currencies/1
  # GET /currencies/1.json
  def show
  end

  # GET /currencies/new
  def new
    authorize! :create, Currency
    @currency = Currency.new
  end

  # GET /currencies/1/edit
  def edit
    authorize! :update, Currency
  end

  # POST /currencies
  # POST /currencies.json
  def create
    authorize! :create, Currency
    @currency = Currency.new(currency_params)

    respond_to do |format|
      if @currency.save
        format.html { redirect_to currencies_url, notice: 'Currency was successfully created.' }
        format.json { render :show, status: :created, location: @currency }
      else
        format.html { render :new }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /currencies/1
  # PATCH/PUT /currencies/1.json
  def update
    authorize! :update, Currency
    respond_to do |format|
      if @currency.update(currency_params)
        format.html { redirect_to currencies_url, notice: 'Currency was successfully updated.' }
        format.json { render :show, status: :ok, location: @currency }
      else
        format.html { render :edit }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.json
  def destroy
    authorize! :destroy, Currency
    @currency.destroy
    respond_to do |format|
      format.html { redirect_to currencies_url, notice: 'Currency was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def currency_params
      params.require(:currency).permit(:foreign, :base, :rate, :user_id)
    end
end
