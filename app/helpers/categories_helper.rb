module CategoriesHelper
  def common_categories
    @common_categories = Category.where('user_id = ? OR user_id = ?', current_user.id, partner(current_user).id).where(common: true)
  end
end
