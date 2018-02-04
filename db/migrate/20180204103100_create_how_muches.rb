class CreateHowMuches < ActiveRecord::Migration[5.1]
  def change
    create_table :how_muches do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.float :percent

      t.timestamps
    end
  end
end
