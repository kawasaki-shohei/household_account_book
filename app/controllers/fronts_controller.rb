class FrontsController < ApplicationController
  def index

  end

  def new
    @expense = Expense.new
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
