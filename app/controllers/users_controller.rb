class UsersController < ApplicationController
  skip_before_action :check_logging_in, only: [:new, :create]
  skip_before_action :check_partner, only: [:new, :create, :register_partner, :edit, :update]
  skip_before_action :check_access_right, only: [:new, :create], raise: false

  def new
    @user = User.new
    render layout: 'sessions'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to edit_user_path, notice: '登録ありがとうございます。パートナーをご登録ください。'
    else
      render 'new', layout: 'sessions'
    end
  end

  def edit
    @user = @current_user
    @partner = @user.partner
  end

  def update
    if @current_user.update(user_params)
      if @current_user.partner_email_to_register
        @current_user.partner.build_couple.register_partner!(@current_user.email)
      end
      redirect_to edit_user_path, notice: 'アカウントを更新しました。'
    else
      render 'edit'
    end
  end

  private
  def user_params
   parameters = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    if params[:user][:partner_email_to_register] != ""
      parameters[:partner_email_to_register] = params[:user][:partner_email_to_register]
    end
   parameters
  end
end
