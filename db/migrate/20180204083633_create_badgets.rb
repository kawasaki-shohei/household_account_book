class Createbudgets < ActiveRecord::Migration[5.1]
  def change
    create_table :budgets do |t|
      t.integer :amount
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
