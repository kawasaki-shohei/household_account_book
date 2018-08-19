class AddPartnerIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :partner, index: {unique: true}, references: :users, foreign_key: { to_table: :users }
  end
end