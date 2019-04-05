class FrontsController < ApplicationController
  def index
    @incomes = current_user.incomes.order(date: :desc).page(params[:page]).per(10)
  end

  def new
    @deposit = current_user.deposits.build
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end


end
