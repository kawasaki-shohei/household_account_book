class RemoveMsgFromNotificationMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :notification_messages, :msg
  end
end
