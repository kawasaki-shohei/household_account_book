class AddPercentDefaultInExpenses < ActiveRecord::Migration[5.2]
  def up
    change_column_default :expenses, :percent, 0
  end

  def down
    change_column_default :expenses, :percent, nil
  end
end
