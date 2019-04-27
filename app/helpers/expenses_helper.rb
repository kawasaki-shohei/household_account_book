# 出費一覧・入力画面で使うヘルパー
module ExpensesHelper

  def back_btn_to_analyses_page
    link_to '出費概要へ', analyses_path(analyses_params_with_category), class: "btn btn-brown space-bottom"
  end

  def back_btn_to_expenses_list
    link_to '出費一覧へ', expenses_path(period: @expense.date.to_s_as_period, category_id: @expense.category.id, expense: @expense.id), class: "btn btn-brown space-bottom"
  end

  def analyses_params
    parameters = {}
    conditions = %w(period tab category)
    expenses_list_params = session[:expenses_list_params]
    expenses_list_params.each do |key, value|
      if conditions.include?(key)
        parameters[key.to_sym] = value
      end
    end
    parameters
  end

  def analyses_params_with_category
    analyses_params.merge(category:  @category.id)
  end

  # 出費入力のときに割合の選択肢
  def percent_selection
    Expense.percents.map do |k, v|
      next if k == "manual_amount"
      [t("activerecord.enum.expense.percent.#{k}"), v]
    end.compact
  end

end
