class BalancesController < ApplicationController
  def index
    @balances = current_user.balances.order(month: :desc).page(params[:page])
  end
end
