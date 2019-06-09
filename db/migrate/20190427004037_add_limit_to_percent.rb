class AddLimitToPercent < ActiveRecord::Migration[5.2]
  def up
    change_column :expenses, :percent, :integer, limit: 2, null: false
  end

  def down
    change_column :expenses, :percent, :integer
  end
end
