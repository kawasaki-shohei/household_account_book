module BadgetsHelper
  # FIXME: sql叩きすぎ！
  # 予算が未入力のカテゴリを抽出
  def make_left_categories(categories)
    all_categories = Hash.new
    categories.each do |category|
      all_categories[category.kind] = category.id
    end
    left_categories = all_categories
    unless Badget.find_by(user_id: current_user.id).present?
      return left_categories
    end
    badgets = current_user.badgets
    badget_categories = Array.new
    badgets.each do |badget|
      category = badget.category.kind
      badget_categories << category
    end

    badget_categories.each do |category_kind|
      left_categories.delete(category_kind)
    end

    return left_categories
  end

  # @param [Category] categories
  # @return [String]
  # @note categories collectionsからuserの全てのbadgetsを取得して、合計値を算出する
  def badgets_sum(categories)
    return "0" if categories.blank?
    categories.map do |category|
      category.user_badget(@current_user)
    end.compact.sum(&:amount).to_s(:delimited)
  end

end
