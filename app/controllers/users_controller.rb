class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    check = Partner.find_by(user_id: current_user.id)
    if check.present?
      @partner = User.find(check.partner_id)
    end
  end


  def edit
  end

  private
   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
end
