class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notification_message

  def details
    meta = JSON.parse(self.record_meta)
    details = Hash.new
    case self.notification_message.func
    when "wants", "bought_buttons"
      details['商品'] = meta['name']
    when "expenses", "repeat_expenses"
      details['カテゴリ'] = Category.find(meta['category_id'].to_i).kind
      details['金額'] = "#{(meta['amount'].to_i).to_s(:delimited)}円"
    when "categories"
      details['カテゴリ名'] = meta['kind']
    when "pays"
      details['該当月'] = Date.parse(meta['date']).strftime("%Y年%m月")
      details['金額'] = "#{(meta['pamount'].to_i).to_s(:delimited)}円"
    # partnerによって通知されるからpaysとは逆の計算になる。
    when "notifications"
      details['該当月'] = Date.parse(meta['date']).strftime("%Y年%m月")
      if meta['pamount'].to_i > 0
        details['金額'] = "#{(meta['pamount'].to_i).abs.to_s(:delimited)}円受け取る"
      elsif meta['pamount'].to_i < 0
        details['金額'] = "#{(meta['pamount'].to_i).abs.to_s(:delimited)}円渡す"
      elsif meta['pamount'].to_i == 0
        details['金額'] = "0円"
      end
    end
    return details
  end

  def change_read_flg
    self.update(read_flg: true)
  end

  def self.notify_payment
    users = User.all
    users.each do |user|
      check = Partner.find_by(user_id: user.id)
      if check.present?
        partner = User.find(check.partner_id)
        my_last_payment = Expense.expense_in_both_last_month(user, partner)
        Notification.create(user_id: user.id,
          notification_message_id: 18,
          record_meta: "{\"pamount\":#{my_last_payment},\"date\":\"#{Date.today.months_ago(1)}\"}"
        )
      else
        next
      end
    end
  end
end
