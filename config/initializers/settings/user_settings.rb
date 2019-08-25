class UserSettings < Settingslogic
  source "#{Rails.root}/config/settings/user_settings.yml"
  namespace Rails.env
end