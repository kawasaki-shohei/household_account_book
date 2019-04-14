class AnalysesController < ApplicationController
  def index
    unless params[:tab] == 'expenses' || params[:tab] == 'budgets'
      params[:tab] = 'expenses'
    end
    @categories = Category.available_categories_with_expenses(@current_user, year_month_params)
    gon.analyses_path = analyses_path
    gon.current_year_month = year_month_params
    gon.first_tab = params[:tab]
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
end
