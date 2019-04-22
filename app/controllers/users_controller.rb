class UsersController < ApplicationController
  skip_before_action :check_logging_in, only: [:new, :create]
  skip_before_action :check_partner, only: [:new, :create, :register_partner, :edit]
  # include UsersHelper

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
      redirect_to edit_user_path, notice: 'アカウントを更新しました。'
    else
      render 'edit'
    end
  end

  def register_partner
    if @partner = User.find_by(email: params[:user][:partner_email])
      @user.assign_attributes(partner_id: @partner.id)
      @user.save(validate: false)
      @partner.assign_attributes(partner_id: @user.id)
      @partner.save(validate: false)
      redirect_to root_path, notice: "#{@partner.name}さんをパートナーとして登録しました。"
    else
      @user.errors[:base] << 'パートナーが登録されていません。'
      render 'show'
    end
  end

  private
  def user_params
   params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
