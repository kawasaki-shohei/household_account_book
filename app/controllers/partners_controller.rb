class PartnersController < ApplicationController
  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    @partner.save
  end
end

  private
  def partner_params
    params.require(:partner).permit(:email).merge(user_id: current_user.id, partner_id: User.find_by(eamil: params[:partner][:email]).id)
  end
