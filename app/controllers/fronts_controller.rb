class FrontsController < ApplicationController
  def index
    @my_categories = current_user.categories.oneself
    @common_categories = Category.where('user_id = ? OR user_id = ?', current_user.id, partner.id).where(common: true)
  end

  def new
    @income = current_user.incomes.build
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end


end
