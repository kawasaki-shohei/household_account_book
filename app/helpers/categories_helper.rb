module CategoriesHelper
  def common_categories
    @common_categories = Category.where('user_id = ? OR user_id = ?', current_user.id, partner.id).where(common: true)
  end
end
