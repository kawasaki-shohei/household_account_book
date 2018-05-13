class DropAndCreateRepeatExpenses < ActiveRecord::Migration[5.1]
  def change
    remove_column :expenses, :repeat_expense_id
    drop_table :repeat_expenses
    create_table :repeat_expenses do |t|
      t.integer :amount
      t.date :s_date
      t.date :e_date
      t.integer :r_date
      t.string :note
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :both_flg, default: false
      t.integer :mypay
      t.integer :partnerpay
      t.integer :percent
      t.timestamps
    end
    add_reference :expenses, :repeat_expense, foreign_key: true
  end
end
