class HomeController < ApplicationController
  skip_before_action :check_logging_in
  skip_before_action :check_partner
  skip_before_action :count_header_notifications, raise: false
  skip_before_action :check_access_right, raise: false

  def index
  end
end
