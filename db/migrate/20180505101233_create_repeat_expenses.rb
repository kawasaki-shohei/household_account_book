class CreateRepeatExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :repeat_expenses do |t|
      t.integer :ramount
      t.date :s_date
      t.date :e_date
      t.string :note
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :both_flg, default: false
      t.integer :mypay
      t.integer :partnerpay
      t.integer :percent

      t.timestamps
    end
  end
end
