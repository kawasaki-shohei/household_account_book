class RemoveUserIdAndCategoryIdFromHowmuches < ActiveRecord::Migration[5.1]
  def change
    remove_column :how_muches, :user_id
    remove_column :how_muches, :category_id
    add_column :how_muches, :expense_id, :integer
  end
end
