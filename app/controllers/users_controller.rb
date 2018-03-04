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
    partner_id = (Partner.find_by(user_id: current_user.id).id)
    @partner = User.find(partner_id)
  end


  def edit
  end

  private
   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
end
