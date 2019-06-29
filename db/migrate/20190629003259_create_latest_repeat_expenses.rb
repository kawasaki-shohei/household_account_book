class CreateLatestRepeatExpenses < ActiveRecord::Migration[5.2]
  def change
    create_view :latest_repeat_expenses
  end
end
