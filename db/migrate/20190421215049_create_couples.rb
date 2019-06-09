class CreateCouples < ActiveRecord::Migration[5.2]
  def change
    create_table :couples do |t|
      t.references :user, index: {unique: true}, foreign_key: true
      t.references :partner, index: {unique: true}, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
