class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notification_message
end
