module AnalysesHelper

  # @return String
  def current_japanese_period
    current_period.to_japanese_period
  end

  # @return String
  def current_period
    if params[:period]
      params[:period]
    else
      Date.current.to_s_as_period
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

  def this_month(categories)
    categories.select do |c|
      c.expenses.find{ |e| e.date >= current_period.to_beginning_of_month && e.date <= current_period.to_end_of_month }
    end
  end

  # 支出合計額の算出
  # @return Integer
  def one_total_expenditures(user)
    @categories.map{ |c| c.expenses_sum(@expenses, user)}.sum
  end
  alias_method(:own_total_expenditures, :one_total_expenditures)
  alias_method(:partner_total_expenditures, :one_total_expenditures)

  # 二人の出費の合計額の算出
  # @return Integer
  def one_total_both_expenditures(user)
    @categories.map{ |c| c.both_expenses_sum(@expenses, user)}.sum
  end

  # 自分の出費の合計額の算出
  # @return Integer
  def one_total_own_expenditures(user)
    @categories.map{ |c| c.own_expenses_sum(@expenses, user)}.sum
  end

  # 前月の分析ページへ遷移するボタン
  def to_analyses_last_month_btn
    icon = tag.i(class: "fa fa-lg fa-angle-double-left")
    if params[:period]
      period = params[:period].to_last_period
    else
      period = Date.current.to_s_as_period.to_last_period
    end
    link_to icon, analyses_path(tab: specify_tab, period: period), class: "btn btn-orange col-xs-2 text-center", id: "last-month-btn"
  end

  # 来月の分析ページへ遷移するボタン
  def to_analyses_next_month_btn
    icon = tag.i(class: "fa fa-lg fa-angle-double-right")
    if params[:period]
      period = params[:period].to_next_period
    else
      period = Date.current.to_s_as_period.to_next_period
    end
    link_to icon, analyses_path(tab: specify_tab, period: period), class: "btn btn-orange col-xs-2 text-center space-right", id: "next-month-btn"
  end

  def options_for_year_month
    default = params[:period] ? params[:period] : Date.current.to_s_as_period
    term = CONFIG[:selection_year_term] * 12  # 30年
    start_date = default.to_beginning_of_month.months_ago(term)
    container = []
    0.step(term * 2, 1) do |n|
      key = start_date.months_since(n).to_japanese_period
      value = start_date.months_since(n).to_s_as_period
      container << [key, value]
    end
    options_for_select(container, default)
  end

  def categories_without_only_partner_own
    @categories.reject{ |c| c.only_ones_own?(@partner) }
  end

  def total_income
    @incomes.sum(&:amount)
  end

  # @param [Integer] total_money 収入か予算
  def show_balance(amount)
    text_color = amount >= 0 ? '': 'text-redpepper'
    content_tag(:span, class: text_color) do
      concat "残り "
      concat tag.i(class: "fa fa-cny")
      concat " #{amount.to_s(:delimited)}"
    end
  end

  # @param [Integer] numerator 分子
  # @param [Integer] denominator 分母
  def balance_percentage(numerator, denominator)
    return 100 if numerator >= denominator
    numerator * 100 / denominator
  end

end
