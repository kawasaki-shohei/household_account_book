class CreateDevides < ActiveRecord::Migration[5.1]
  def change
    create_table :devides do |t|
      t.float :percent
      t.references :expense, foreign_key: true

      t.timestamps
    end
  end
end
