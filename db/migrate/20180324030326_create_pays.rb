class CreatePays < ActiveRecord::Migration[5.1]
  def change
    create_table :pays do |t|
      t.integer :pamount
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
