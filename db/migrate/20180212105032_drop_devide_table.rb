class DropDevideTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :devides
  end
end
