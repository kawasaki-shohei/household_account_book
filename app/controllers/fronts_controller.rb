class FrontsController < ApplicationController
  def index
    # @cnum = 0
    # @expenses = Expense.all_for_one_month(@current_user, year_month_params)
    # @current_user_expenses = current_user.expenses.this_month
    # @partner_expenses = partner.expenses.this_month

    @categories = Category.available_categories_with_expenses(@current_user, year_month_params)
    # @incomes = current_user.incomes.where('date >= ? AND date <= ?', Date.current.beginning_of_month, Date.current.end_of_month)
    # @balances = current_user.balances
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
      return Date.current.month_as_string
    elsif params[:period].is_invalid_year_month?
     raise 'error'
    else
      params[:period]
    end
  end


end
