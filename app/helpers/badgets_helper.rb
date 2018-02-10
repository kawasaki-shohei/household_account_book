module BadgetsHelper
  def make_left_categories
    badgets = Badget.all
    categories = Category.all
    all_categories = Hash.new
    categories.each do |category|
      all_categories[category.kind] = category.id
    end

    badget_categories = Array.new
    badgets.each do |badget|
      category = badget.category.kind
      badget_categories << category
    end

    left_categories = all_categories
    badget_categories.each do |category_kind|
      left_categories.delete(category_kind)
    end
    
    return left_categories
  end
end
