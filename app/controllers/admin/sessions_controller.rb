class Admin::SessionsController < AdminController
  skip_before_action :check_logging_in, only: [:new, :create]

  def new
    if logged_in?
      redirect_to admin_top_path
    end
  end

  def create
    admin = Admin.find_by(email: params[:session][:email])
    if admin&.authenticate(params[:session][:password])
      session[:admin_id] = admin.id
      redirect_to admin_top_path
    else
      redirect_to admin_login_path, alert: 'メールアドレスまたはパスワードが違います。'
    end
  end

  def destroy
    session.delete(:admin_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to admin_login_path
  end

end