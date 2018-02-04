class AddBothFlgToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :both_flg, :boolean, default: false
  end
end
