class NotificationsController < ApplicationController

  def index
    @notifications = partner.notifications.order(created_at: :desc)
    @notification_count = partner.notifications.where(read_flg: false).count
  end
end
