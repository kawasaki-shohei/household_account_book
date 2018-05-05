class AddRepeateExpenseIdToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_reference :expenses, :repeat_expense, foreign_key: true
  end
end
