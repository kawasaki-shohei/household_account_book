class FrontsController < ApplicationController
  def index
    @categories = @current_user.categories
  end

  def new
    @repeat_expense = RepeatExpense.new
    @categories = Category.ones_categories(@current_user)
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end

  private
  # def expenses_search_params
  #   params[:year_month].date_condition_of_query
  # end


end
