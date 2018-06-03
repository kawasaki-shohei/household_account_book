class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :notification_message, foreign_key: true
      t.integer :notified_by_id
      t.text :record_meta, null: false
      t.boolean :read_flg, default: false

      t.timestamps
    end
  end
end
