class AddCategoryMasterIdToCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :category_master, foreign_key: true
  end
end
