class SettingsController < ApplicationController
  def index
  end

  def change_allow_share_mine
    @user = current_user
    @user.assign_attributes(allow_share_mine: @user.allow_share_mine ? false : true)
    @user.save(validate: false)
  end
end
