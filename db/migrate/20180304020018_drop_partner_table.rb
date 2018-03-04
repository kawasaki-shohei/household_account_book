class DropPartnerTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :partners
  end
end
