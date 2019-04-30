class NotificationsController < ApplicationController
  skip_before_action :count_header_notifications, raise: false

  def index
    @notifications = @partner.notifications.includes(:user, :notification_message).order(created_at: :desc).page(params[:page])
    @notification_count = partner.notifications.where(read_flg: false).count
  end

  def update
    notification = Notification.find(params[:id])
    notification.update!(read_flg: true)
    redirect_to redirect_path(notification)
  end

  def bulk_update
    ids = params[:notifications][:ids].split(/\s/).to_a
    checked_ids = ids.select do |id|
      params[:notifications][id.to_s]
    end
    @partner.notifications.where(id: checked_ids).update_all(read_flg: true)
    redirect_to notifications_path, notice: "既読にしました。"
  end

  private
  # todo: decoratorのlinkメソッドと同じロジック。共通化したい。
  def redirect_path(notification)
    record_meta = notification.record_meta
    case notification.notification_message.func
    when "expenses"
      expenses_path(
        category_id: record_meta["category_id"],
        period: Date.parse(record_meta["date"]).to_s_as_period,
        expense: record_meta["id"]
      )
    when "repeat_expenses"
      repeat_expenses_path
    when "categories"
      categories_path
    when "pays"
      pays_path
      # when "wants", "bought_buttons"
      #   wants_path
    end
  end
end
