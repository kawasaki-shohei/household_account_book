class AnalysesController < ApplicationController
  def index
    unless params[:tab] == 'expenses' || params[:tab] == 'budgets'
      params[:tab] = 'expenses'
    end
    @categories = Category.available_categories_with_budgets(@current_user)
    @expenses = Expense.all_for_one_month(@current_user, year_month_params)
    @incomes = @current_user.incomes.where(income_params)
    @balance = @current_user.balances.find_by(month: year_month_params)
    session[:expenses_list_params] = params
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
