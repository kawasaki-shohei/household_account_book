module BadgetsHelper
  # 予算が未入力のカテゴリを抽出
  def make_left_categories(user)
    left_categories = {}
    @categories.each do |category|
      next if category.is_set_own_badget?(user)
      left_categories[category.kind] = category.id
    end
    left_categories
  end

  # @param [Category] categories
  # @return [Integer]
  # @note categories collectionsからuserの全てのbadgetsを取得して、合計値を算出する
  def total_badget
    return "0" if @categories.blank?
    @categories.map do |category|
      category.user_badget(@current_user)
    end.compact.sum(&:amount)
  end

end
