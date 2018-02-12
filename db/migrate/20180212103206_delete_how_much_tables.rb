class DeleteHowMuchTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :how_muches
  end
end
