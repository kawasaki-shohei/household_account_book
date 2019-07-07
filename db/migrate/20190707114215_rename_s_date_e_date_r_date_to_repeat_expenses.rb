class RenameSDateEDateRDateToRepeatExpenses < ActiveRecord::Migration[5.2]
  def change
    rename_column :repeat_expenses, :s_date, :start_date
    rename_column :repeat_expenses, :e_date, :end_date
    rename_column :repeat_expenses, :r_date, :repeat_day
  end
end
