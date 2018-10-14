class AddSysAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sys_admin, :boolean, default: false
  end
end
