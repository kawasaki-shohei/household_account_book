class AddDeletedAtToRepeatExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :repeat_expenses, :deleted_at, :datetime
    add_index :repeat_expenses, :deleted_at
  end
end
