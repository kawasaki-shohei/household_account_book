module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def check_logging_in
    unless logged_in?
      redirect_to new_session_path
    end
  end
end
