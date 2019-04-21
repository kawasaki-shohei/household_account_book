class RemovePartnerIdInUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :partner_id
  end

  def down
    add_reference :users, :partner, index: {unique: true}, references: :users, foreign_key: { to_table: :users }
  end
end
