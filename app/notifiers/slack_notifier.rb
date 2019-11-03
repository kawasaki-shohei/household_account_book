class SlackNotifier
  WEBHOOK_URL = SlackSettings.slack_webhook_url

  attr_accessor :notifier, :channel, :request, :session
  def initialize(request=nil, session=nil)
    @channel = Rails.env
    @notifier = Slack::Notifier.new(WEBHOOK_URL, channel: @channel)
    @request = request
    @session = session
  end

  def notify_starting_demo
    message = <<~TEXT
      #{I18n.t('notification.slack.start_demo')}
      session_id: #{session[:session_id]}
      IP_address: #{request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip}
      user_agent: #{request.env["HTTP_USER_AGENT"]}
    TEXT
    ping(message)
  end

  def notify_succeeded_demo
    message =<<~TEXT
      #{I18n.t('notification.slack.succeeded_demo')}
      session_id: #{session[:session_id]}
    TEXT
    ping(message)
  end

  def notify_failed_demo
    message =<<~TEXT
      #{I18n.t('notification.slack.failed_demo')}
      session_id: #{session[:session_id]}
    TEXT
    ping(message)
  end

  def notify_new_user_registration(user)
    message = <<~TEXT
      #{I18n.t('notification.slack.new_user_registration')}
      username: #{user.name}
      email: #{user.email}
      session_id: #{session[:session_id]}
      IP_address: #{request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip}
      user_agent: #{request.env["HTTP_USER_AGENT"]}
    TEXT
    ping(message)
  end

  private

  def ping(message)
    message_to_send = <<~TEXT
      ======================= notification =======================
      #{message}
      ============================================================
    TEXT
    begin
      @notifier.ping(message_to_send)
    rescue Slack::Notifier::APIError => e
      LoggerUtility.error_log(e)
    end
  end
end