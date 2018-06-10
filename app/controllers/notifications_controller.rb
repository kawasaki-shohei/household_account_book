class NotificationsController < ApplicationController

  def index
    @notifications = partner.notifications.order(created_at: :desc)
  end
end
