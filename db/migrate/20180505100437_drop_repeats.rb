class DropRepeats < ActiveRecord::Migration[5.1]
  def change
    drop_table :repeats
  end
end
