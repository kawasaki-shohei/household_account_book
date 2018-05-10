class AddDateToRepeatExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :repeat_expenses, :date, :date
  end
end
