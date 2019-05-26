class SessionsController < ApplicationController
  skip_before_action :check_logging_in
  skip_before_action :check_partner
  skip_before_action :count_header_notifications, raise: false
  skip_before_action :check_access_right, raise: false

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to login_path, alert: 'メールアドレスまたはパスワードが違います。'
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:partner_mode)
    flash[:notice] = 'ログアウトしました'
    redirect_to login_path
  end

end
