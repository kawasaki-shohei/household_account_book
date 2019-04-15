module CategoriesHelper
  #fixme: ビューで呼ばれているから要修正
  def common_categories
    @common_categories = Category.where('user_id = ? OR user_id = ?', current_user.id, partner.id).where(common: true)
  end

  def user_own_and_common_categories(categories)
    categories.find_all do |category|
      user = category.user
      user == @current_user ||
        (user == @partner && category.common)
    end
  end

  def partner_categories(categories)
    categories.find_all do |category|
      category.only_ones_own?(@partner)
    end
  end
end
