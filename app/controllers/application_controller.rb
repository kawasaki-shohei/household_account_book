class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_logging_in
  before_action :check_partner
  include SessionsHelper, UsersHelper

  def notification_msg
    notification_msg_id = NotificationMessage.find_by(func: controller_path, act: action_name).msg_id
    return notification_msg_id
  end

  def check_need_notify(obj)
    if controller_path == "expenses" && obj.both_flg == false
      return true
    elsif controller_path == "repeat_expenses" && obj.both_flg == false
      return true
    elsif controller_path == "categories" && obj.common == false
      return true
    else
      return false
    end
  end

  #fixme: コールバックでするように移動。
  def create_notification(obj)
    unless check_need_notify(obj)
      Notification.create(user_id: current_user.id,
        notification_message_id: notification_msg,
        notified_by_id: obj.id,
        record_meta: obj.to_json
      )
    end
  end
end
