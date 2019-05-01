class PartnerModesController < ApplicationController
  skip_before_action :count_header_notifications, raise: false

  def create
    session[:patner_mode] = true
    redirect_to request.referer
  end

  def destroy
    session.delete(:patner_mode)
    redirect_to request.referer
  end
end
