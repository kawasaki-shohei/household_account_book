class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notification_message

  def details
    meta = JSON.parse(self.record_meta)
    details = Hash.new
    case self.notification_message.func
    when "wants"
      details['商品'] = meta['name']
    return details
    end
  end
end
