class LatePassengersController < ApplicationController
  # PATCH /pax/1.json
  def update
    @pax = LatePassenger.find params[:id]
    if @pax.update(late_passenger_params)
      @pax.carpool.touch
      render json: @pax
    else
      render json: @pax.errors, status: :unprocessable_entity
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def late_passenger_params
      params.require(:late_passenger).permit( :active )
    end
end