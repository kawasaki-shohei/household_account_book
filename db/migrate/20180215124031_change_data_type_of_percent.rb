class ChangeDataTypeOfPercent < ActiveRecord::Migration[5.1]
  def change
    remove_column :expenses, :percent
    add_column :expenses, :percent, :integer
  end
end
