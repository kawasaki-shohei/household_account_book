class BoughtButtonsController < ApplicationController
  # after_action -> {create_notification(@want)}
  # def bought
  #   @want = Want.find(params[:id])
  #   if @want.bought_flg == false
  #     @want.update(bought_flg: true)
  #   end
  #   respond_to do |format|
  #     format.js {render :bought_buttons}
  #   end
  # end
  #
  # def want
  #   @want = Want.find(params[:id])
  #   if @want.bought_flg == true
  #     @want.update(bought_flg: false)
  #   end
  #   respond_to do |format|
  #     format.js {render :bought_buttons}
  #   end
  # end
end
