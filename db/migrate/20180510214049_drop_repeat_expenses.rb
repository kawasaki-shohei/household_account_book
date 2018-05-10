class DropRepeatExpenses < ActiveRecord::Migration[5.1]
  def change
    remove_column :expenses, :repeat_expense_id
    drop_table :repeat_expenses
  end
end
