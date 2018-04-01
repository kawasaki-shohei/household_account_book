class PartnersController < ApplicationController

  def new
    @new_partner = Partner.new
  end

  def create
    @partner = User.find_by(email: params[:partner][:email])
    if @partner.nil?
      redirect_to new_partner_path, notice: "入力されたメールアドレスのユーザーは存在しません。"
    elsif (@new_partner = Partner.new(user_id: current_user.id, partner_id: @partner.id)).present?
      @new_partner.save
      Partner.create(user_id: @partner.id, partner_id: current_user.id)
      redirect_to user_path(current_user), notice: "#{@partner.name}さんをパートナーとして登録しました。"
    else
      render 'new', notice: "そのユーザーはすでにパートナーがいます。"
    end
  end

end
