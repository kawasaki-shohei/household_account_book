module BadgetsHelper
  def make_left_categories
    categories = current_user.categories
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
end
