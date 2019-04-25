class NotificationsController < ApplicationController
  skip_before_action :count_notifications

  def index
    @notifications = @partner.notifications.includes(:user, :notification_message).order(created_at: :desc).page(params[:page])
    @notification_count = partner.notifications.where(read_flg: false).count
  end
end
