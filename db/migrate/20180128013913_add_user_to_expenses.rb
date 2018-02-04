class AddUserToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :user_id, :integer
  end
end
