class AdminController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_logging_in
  helper_method :logged_in?

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def logged_in?
    !current_admin.nil?
  end

  def check_logging_in
    unless logged_in?
      redirect_to admin_login_path
    end
  end
end
