class CreateNotificationMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_messages do |t|

      t.string :func
      t.string :act
      t.text :msg
    end
  end
end
