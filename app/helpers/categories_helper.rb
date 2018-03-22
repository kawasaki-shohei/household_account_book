module CategoriesHelper
  def common_categories
    unless partner(current_user).nil?
      @common_categories = Category.where('user_id = ? OR user_id = ?', current_user.id, partner(current_user).id).where(common: true)
    end
  end
end
