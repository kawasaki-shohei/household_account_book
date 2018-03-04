class PartnersController < ApplicationController

  def new
    @new_partner = Partner.new
  end

  def create
    @partner = User.find_by(email: params[:partner][:email])
    if @partner.nil?
      redirect_to new_partner_path, notice: "入力されたメールアドレスのユーザーは存在しません。"
    else
      @new_partner = Partner.create(user_id: current_user.id, partner_id: @partner.id)
      redirect_to user_path(current_user), notice: "#{@partner.name}さんをパートナーとして登録しました。"
    end
  end

  # private
  # def partner_params
  #   params.require(:partner).permit(:email).merge(user_id: current_user.id, partner_id: @partner.id)
  # end

end
