class AnalysesController < ApplicationController
  def index
    @categories = Category.available_categories_with_expenses(@current_user, year_month_params)
    gon.analyses_path = analyses_path
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
