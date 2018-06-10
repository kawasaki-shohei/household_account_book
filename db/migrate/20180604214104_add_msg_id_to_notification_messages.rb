class AddMsgIdToNotificationMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :notification_messages, :msg_id, :integer
    add_index :notification_messages, :msg_id, unique: true
  end
end
