class UsersController < ApplicationController
  include UsersHelper

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_partner_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    partner(current_user)
  end


  def edit
  end

  private
   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
end
