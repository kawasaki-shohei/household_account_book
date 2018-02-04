class AddCategoryToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :category_id, :integer
  end
end
