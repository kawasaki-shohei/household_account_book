class AddItemIdAndItemSubIdToRepeatExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :repeat_expenses, :item_id, :integer
    add_column :repeat_expenses, :item_sub_id, :integer
    add_index :repeat_expenses, [:user_id, :item_id, :item_sub_id], unique: true
  end
end
