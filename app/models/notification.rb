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
    end
    return details
  end
end
