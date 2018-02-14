class AddTwoColumnsToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :mypay, :integer
    add_column :expenses, :partnerpay, :integer
  end
end
