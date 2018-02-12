class AddPercentToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :percent, :float, default: 1
  end
end
