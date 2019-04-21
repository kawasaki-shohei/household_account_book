module BudgetsHelper
  # 予算が未入力のカテゴリを抽出
  def make_left_categories(categories)
    all_categories = Hash.new
    categories.each do |category|
      all_categories[category.kind] = category.id
    end
    left_categories = all_categories
    unless Budget.find_by(user_id: current_user.id).present?
      return left_categories
    end
    budgets = current_user.budgets
    budget_categories = Array.new
    budgets.each do |budget|
      category = budget.category.kind
      budget_categories << category
    end

    budget_categories.each do |category_kind|
      left_categories.delete(category_kind)
    end

    return left_categories
  end
end
