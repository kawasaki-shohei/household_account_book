class CreateBalances < ActiveRecord::Migration[5.1]
  def change
    create_table :balances do |t|
      t.references :user, foreign_key: true
      t.string :month
      t.integer :amount

      t.timestamps
    end
  end
end
