class FrontsController < ApplicationController
  def index
    # カテゴリーとyear,month
    @expenses = Expense.specified_category_for_one_month(@current_user, params[:category_id], params[:period])
  end

  def new
    @income = current_user.incomes.build
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end

  private
  def expenses_search_params
    params[:year_month].date_condition_of_query
  end


end
