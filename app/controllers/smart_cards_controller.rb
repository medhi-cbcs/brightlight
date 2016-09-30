class SmartCardsController < ApplicationController

  # GET /smart_cards/1.json
  def show
    @smart_card = SmartCard.includes(:transport).find_by_code(params[:id])
    unless @smart_card
      render json: :no_header, status: :unprocessable_entity
    end
  end

  # POST /smart_cards.json
  def create
    @smart_card = SmartCard.new smart_card_params

    if @smart_card.save
      render json: @smart_card
    else
      render json: @smart_card.errors, status: :unprocessable_entity
    end
    respond_to :json
  end

  # DELETE /smart_cards/1.json
  def destroy
    @smart_card = SmartCard.find_by_code(params[:id])
    @smart_card.destroy

    render json: @smart_card
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def smart_card_params
      params.require(:smart_card).permit( :code, :transport_id, :detail, :ref )
    end
end