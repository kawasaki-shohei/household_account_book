class FrontsController < ApplicationController
  def index
    unless params[:tab] == 'expenses' || params[:tab] == 'budgets'
      params[:tab] = 'expenses'
    end
    @categories = Category.available_categories_with_expenses(@current_user, year_month_params)
    @expenses = Expense.all_for_one_month(@current_user, year_month_params)
    @incomes = @current_user.incomes.where(income_params)
    @badget_categories = Category.get_user_categories_with_badgets(current_user)
  end

  def new
    @income = current_user.incomes.build
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end

  private
  def year_month_params
    if params[:period].nil?
      return Date.current.to_s_as_year_month
    elsif params[:period].is_invalid_year_month?
      raise 'error'
    else
      params[:period]
    end
  end

  def income_params
    params[:period].try(:date_condition_of_query) ||
      Date.date_condition_of_query
  end


end
