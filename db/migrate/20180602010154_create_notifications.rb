class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.string :func
      t.string :act
      t.integer :notified_by_id
      t.boolean :read_flg, default: false

      t.timestamps
    end
  end
end
