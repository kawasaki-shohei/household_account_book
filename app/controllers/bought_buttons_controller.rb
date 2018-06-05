class BoughtButtonsController < ApplicationController

  def bought
    @want = Want.find(params[:id])
    if @want.bought_flg == false
      @want.update(bought_flg: true)
    end
    respond_to do |format|
      format.js {render :bought_buttons}
    end
  end

  def not_yet
    @want = Want.find(params[:id])
    if @want.bought_flg == true
      @want.update(bought_flg: false)
    end
    respond_to do |format|
      format.js {render :bought_buttons}
    end
  end
end
