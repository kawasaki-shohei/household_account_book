class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_logging_in
  before_action :check_partner
  include SessionsHelper, UsersHelper, NotificationsHelper

end
