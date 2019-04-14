module AnalysesHelper
  # 支出合計額の算出
  # @return Integer
  def one_total_expenditures(categories, user)
    categories.map{ |c| c.expenses_sum(user)}.sum
  end
  alias_method(:own_total_expenditures, :one_total_expenditures)
  alias_method(:partner_total_expenditures, :one_total_expenditures)

  # 二人の出費の合計額の算出
  # @return Integer
  def one_total_both_expenditures(categories, user)
    categories.map{ |c| c.own_both_expenses_mypay_sum(user)}.sum +
      categories.map{ |c| c.partner_both_expenses_partnerpay_sum(user)}.sum
  end

  # 自分の出費の合計額の算出
  # @return Integer
  def one_total_own_expenditures(categories, user)
    categories.map{ |c| c.own_expenses_sum(user)}.sum
  end

  def to_last_month_btn
    icon = tag.i(class: "fa fa-lg fa-angle-double-left")
    if params[:period]
      year_month = params[:period].to_last_year_month
    else
      year_month = Date.current.to_s_as_year_month.to_last_year_month
    end
    link_to icon, analyses_path(tab: specify_tab, period: year_month), class: "btn btn-orange col-xs-2 text-center", id: "last-month-btn"
  end

  def to_next_month_btn
    icon = tag.i(class: "fa fa-lg fa-angle-double-right")
    if params[:period]
      year_month = params[:period].to_next_year_month
    else
      year_month = Date.current.to_s_as_year_month.to_next_year_month
    end
    link_to icon, analyses_path(tab: specify_tab, period: year_month), class: "btn btn-orange col-xs-2 text-center space-right", id: "next-month-btn"
  end

  def options_for_year_month
    default = params[:period] ? params[:period] : Date.current.to_s_as_year_month
    term = CONFIG[:selection_year_term] * 12  # 30年
    start_date = default.to_beginning_of_month.months_ago(term)
    container = []
    0.step(term * 2, 1) do |n|
      key = start_date.months_since(n).to_japanese_year_month
      value = start_date.months_since(n).to_s_as_year_month
      container << [key, value]
    end
    options_for_select(container, default)
  end

  # @return String
  def current_japanese_year_month
    current_year_month.to_japanese_year_month
  end

  # @return String
  def current_year_month
    if params[:period]
      params[:period]
    else
      Date.current.to_s_as_year_month
    end
  end

  def specify_tab
    params[:tab] || 'expenses'
  end

  def active_analyses_tab(tab_name)
    if params[:tab]
      params[:tab] == tab_name ? 'active' : nil
    else
      tab_name == 'expenses' ? 'active' : nil
    end
  end
end
