module NotificationsHelper
  def notification_msg
    notification_message_id = NotificationMessage.find_by(func: controller_path, act: action_name).id
    return notification_message_id
  end
end
