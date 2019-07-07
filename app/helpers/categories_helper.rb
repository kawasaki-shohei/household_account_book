module CategoriesHelper

  def user_own_and_common_categories(categories)
    categories.find_all do |category|
      user = category.user
      user == @current_user ||
        (user == @partner && category.is_common?)
    end
  end

  def partner_categories(categories)
    categories.find_all do |category|
      category.only_ones_own?(@partner)
    end
  end

  def categories_without_only_own
    @categories.reject{ |c| c.only_ones_own?(@current_user) }
  end

end
