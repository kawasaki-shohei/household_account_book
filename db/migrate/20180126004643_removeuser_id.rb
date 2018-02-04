class RemoveuserId < ActiveRecord::Migration[5.1]
  def change
    remove_column :expenses, :user_id
  end
end
