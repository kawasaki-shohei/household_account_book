class BalancesController < ApplicationController
  def index
    @balances = current_user.balances.order(period: :desc).page(params[:page])
  end
end
