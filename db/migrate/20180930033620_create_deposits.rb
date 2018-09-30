class CreateDeposits < ActiveRecord::Migration[5.1]
  def change
    create_table :deposits do |t|
      t.references :user, foreign_key: true
      t.boolean :is_withdrawn, default: false
      t.integer :amount, null: false
      t.datetime :date, null: false
      t.string :memo

      t.timestamps
    end
  end
end
