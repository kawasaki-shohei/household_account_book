class PartnerModesController < ApplicationController
  skip_before_action :check_access_right, raise: false
  skip_before_action :count_header_notifications, raise: false

  def create
    session[:partner_mode] = true
    redirect_to request.referer
  end

  def destroy
    session.delete(:partner_mode)
    redirect_to request.referer
  end
end
