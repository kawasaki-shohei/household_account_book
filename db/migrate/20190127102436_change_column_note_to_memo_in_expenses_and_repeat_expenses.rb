class ChangeColumnNoteToMemoInExpensesAndRepeatExpenses < ActiveRecord::Migration[5.2]
  def change
    rename_column :expenses, :note, :memo
    rename_column :repeat_expenses, :note, :memo
  end
end
