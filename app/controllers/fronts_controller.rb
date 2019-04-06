class FrontsController < ApplicationController
  def index
    @balances = current_user.balances.order(month: :desc).page(params[:page]).per(10)
  end

  def new
    @income = current_user.incomes.build
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end


end
