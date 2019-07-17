class Admin::SessionsController < AdminController
  skip_before_action :check_logging_in

  def new
    if logged_in?
      redirect_to admin_users_path
    end
  end

  def create
  end

  def destroy
  end

end