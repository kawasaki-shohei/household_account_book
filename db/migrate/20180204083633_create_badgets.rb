class CreateBadgets < ActiveRecord::Migration[5.1]
  def change
    create_table :badgets do |t|
      t.money :amount
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
