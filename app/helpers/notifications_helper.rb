module NotificationsHelper
  def notification_msg
    notification_msg_id = NotificationMessage.find_by(func: controller_path, act: action_name).msg_id
    return notification_msg_id
  end
end
