class SessionsController < ApplicationController
  skip_before_action :check_logging_in, only: [:new, :create]
  skip_before_action :check_partner
  skip_before_action :count_header_notifications, raise: false
  skip_before_action :check_access_right, raise: false

  def new
    if logged_in?
      redirect_to mypage_top_path
    end
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to mypage_top_path
    else
      redirect_to login_path, alert: 'メールアドレスまたはパスワードが違います。'
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:preview_user_id)
    session.delete(:partner_mode)
    flash[:notice] = 'ログアウトしました'
    redirect_to login_path
  end

end
