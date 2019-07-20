class RemoveSysAdminFromUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :sys_admin
  end

  def down
    add_column :users, :sys_admin, :boolean, default: false
  end
end
