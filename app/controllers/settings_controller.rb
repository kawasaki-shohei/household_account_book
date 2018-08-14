class SettingsController < ApplicationController
  def index
  end

  def change_allow_share_own
    @user = current_user
    @user.assign_attributes(allow_share_own: @user.allow_share_own ? false : true)
    @user.save(validate: false)
  end
end
