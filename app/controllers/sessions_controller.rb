class SessionsController < ApplicationController
  skip_before_action :check_logging_in
  skip_before_action :check_partner
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:danger] = 'ログインに失敗しました'
      redirect_to new_session_path
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

end
