class NotificationsController < ApplicationController

  def index
    @notifications = partner.notifications.where(read_flg: false).order(created_at: :desc)
  end
end
