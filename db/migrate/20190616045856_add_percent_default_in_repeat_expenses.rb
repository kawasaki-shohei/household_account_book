class AddPercentDefaultInRepeatExpenses < ActiveRecord::Migration[5.2]
  def up
    change_column :repeat_expenses, :percent, :integer, limit: 2, null: false
    change_column_default :repeat_expenses, :percent, 0
  end

  def down
    change_column_default :repeat_expenses, :percent, nil
    change_column :repeat_expenses, :percent, :integer
  end
end
