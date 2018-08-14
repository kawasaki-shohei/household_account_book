class AddAllowShareMineToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :allow_share_mine, :boolean, default: false
  end
end
