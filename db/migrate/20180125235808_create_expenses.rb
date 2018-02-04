class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.money :amount
      t.date :date
      t.string :note
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
