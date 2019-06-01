class AnalysesController < ApplicationController
  include AdjustPeriod

  def index
    unless params[:tab] == 'expenses' || params[:tab] == 'budgets'
      params[:tab] = 'expenses'
    end
    @categories = Category.available_categories_with_budgets(@current_user)
    @expenses = Expense.all_for_one_month(@current_user, period_params)
    @incomes = @current_user.incomes.where(income_params)
    @balance = @current_user.balances.find_by(period: period_params)
    session['analyses_params'] = {tab: params[:tab], period: period_params}
  end

  private
  def income_params
    params[:period].try(:date_condition_of_query) ||
      Date.date_condition_of_query
  end
end
