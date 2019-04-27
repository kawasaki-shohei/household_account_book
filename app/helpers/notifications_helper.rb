module NotificationsHelper
  def unread_notifications
    @notifications.map do |notification|
      next if notification.read_flg
      notification.id
    end.compact
  end
end
