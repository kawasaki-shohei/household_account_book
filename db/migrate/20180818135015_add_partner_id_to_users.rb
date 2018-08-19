class AddPartnerIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :partner, index: true, references: :users
    drop_table :partners
  end
end