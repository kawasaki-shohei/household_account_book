class RenameBothFlgToExpensesAndRepeatExpenses < ActiveRecord::Migration[5.2]
  def change
    rename_column :expenses, :both_flg, :is_for_both
    rename_column :repeat_expenses, :both_flg, :is_for_both
  end
end
