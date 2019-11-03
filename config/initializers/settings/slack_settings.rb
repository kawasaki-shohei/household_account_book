class SlackSettings < Settingslogic
  source "#{Rails.root}/config/settings/slack_settings.yml"
  namespace Rails.env
end