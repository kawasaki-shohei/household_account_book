# ## Schema Information
#
# Table name: `notifications`
#
# ### Columns
#
# Name                           | Type               | Attributes
# ------------------------------ | ------------------ | ---------------------------
# **`id`**                       | `bigint(8)`        | `not null, primary key`
# **`read_flg`**                 | `boolean`          | `default(FALSE)`
# **`record_meta`**              | `text`             | `not null`
# **`created_at`**               | `datetime`         | `not null`
# **`updated_at`**               | `datetime`         | `not null`
# **`notification_message_id`**  | `bigint(8)`        |
# **`notified_by_id`**           | `integer`          |
# **`user_id`**                  | `bigint(8)`        |
#
# ### Indexes
#
# * `index_notifications_on_notification_message_id`:
#     * **`notification_message_id`**
# * `index_notifications_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`notification_message_id => notification_messages.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notification_message

  # fixme: @note コントローラーから移動しただけで使っていない
  # fixme: notified_by_id → object_id_created_by に変更
  # fixme: record_meta → object_attributes_made_notification に変更
  def self.create_notification(obj)
    return if is_unnecessary?(obj)
    Notification.create(user_id: current_user.id,
                        notification_message_id: notification_msg,
                        notified_by_id: obj.id,
                        record_meta: obj.to_json
    )
  end

  # @return [Hash]
  def record_meta
    JSON.parse(self[:record_meta])
  end

  def details
    meta = self.record_meta
    details = Hash.new
    case self.notification_message.func
    when "expenses", "repeat_expenses"
      # fixme: 【N+1】Category.find
      details['カテゴリ'] = Category.find(meta['category_id'].to_i).name
      details['金額'] = "#{(meta['amount'].to_i).to_s(:delimited)}円"
    when "categories"
      details['カテゴリ名'] = meta['name']
    when "pays"
      details['該当月'] = Date.parse(meta['date']).strftime("%Y年%m月")
      details['金額'] = "#{(meta['amount'].to_i).to_s(:delimited)}円"
    # partnerによって通知されるからpaysとは逆の計算になる。
    when "notifications"
      details['該当月'] = Date.parse(meta['date']).strftime("%Y年%m月")
      if meta['amount'].to_i > 0
        details['金額'] = "#{(meta['amount'].to_i).abs.to_s(:delimited)}円受け取る"
      elsif meta['amount'].to_i < 0
        details['金額'] = "#{(meta['amount'].to_i).abs.to_s(:delimited)}円渡す"
      elsif meta['amount'].to_i == 0
        details['金額'] = "0円"
      end
    # when "wants", "bought_buttons"
    #   details['商品'] = meta['name']
    end
    return details
  end

  def change_read_flg
    self.update(read_flg: true)
  end

  def self.notify_payment
    users = User.all
    users.each do |user|
      if partner = user.partner
        my_last_payment = Expense.own_payment_for_one_month(user, Date.current.last_month.to_s_as_period)
        Notification.create(user_id: user.id,
          notification_message_id: 18,
          record_meta: "{\"amount\":#{my_last_payment},\"date\":\"#{Date.current.months_ago(1)}\"}"
        )
      else
        next
      end
    end
  end

  private
  # fixme: @note コントローラーから移動しただけでまだ使っていない
  # @return [Boolean]
  def is_unnecessary?(obj)
    if obj.class == Expense && !obj.is_for_both?
      return true
    elsif obj.class == RepeatExpense && !obj.is_for_both?
      return true
    elsif obj.class == Category && !obj.is_common?
      return true
    elsif obj.class == Deposit
      return true
    else
      return false
    end
  end

  # fixme: @note コントローラーから移動しただけでまだ使っていない
  def notification_msg
    notification_msg_id = NotificationMessage.find_by(func: controller_path, act: action_name).msg_id
    return notification_msg_id
  end
end
