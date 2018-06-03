class NotificationsController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner

  def index
    @notifications = partner.notifications.where(read_flg: false).order(created_at: :desc)
  end
end
