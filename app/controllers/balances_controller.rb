class BalancesController < ApplicationController
  def index
    @balances = current_user.balances.order(month: :desc)
  end
end
