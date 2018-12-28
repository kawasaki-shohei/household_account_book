class CreateIncomes < ActiveRecord::Migration[5.1]
  def change
    create_table :incomes do |t|
      t.references :user, foreign_key: true
      t.integer :amount
      t.date :date
      t.string :memo

      t.timestamps
    end
  end
end
