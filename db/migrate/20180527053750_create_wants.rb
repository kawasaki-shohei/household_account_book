class CreateWants < ActiveRecord::Migration[5.1]
  def change
    create_table :wants do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.boolean :bought_flg, default: false
      t.text :memo

      t.timestamps
    end
  end
end
