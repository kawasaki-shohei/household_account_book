# ## Schema Information
#
# Table name: `balances`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`amount`**      | `integer`          |
# **`period`**      | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_balances_on_user_id`:
#     * **`user_id`**
# * `index_balances_on_user_id_and_period` (_unique_):
#     * **`user_id`**
#     * **`period`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Balance < ApplicationRecord
  belongs_to :user
  validates_presence_of :amount, :period
  validates :period, uniqueness: { scope: :user_id }, format: { with: /\A\d{4}-\d{2}\z/ }
  validate :future_month

  # 来月以降のbalanceは生成しないように、バリデーションチェックをする
  def future_month
    if period.present? && period.to_beginning_of_month > Date.current.beginning_of_month
      errors[:base] << I18n.t('balance.validation.future_month_is_invalid')
    end
  end

  # balance_calculatorによって渡された、注文書(balance_lists)に応じて、balanceを作成する。
  # @param {user: User, period: String, amount: Integer}
  def self.create_or_update_balance(balance_lists)
    LoggerUtility.output_balance_lists(balance_lists)
    balance_lists.each do |list|
      user = list[:user]
      target_period = list[:period]
      balance = user.get_applicable_balance(target_period)
      balance.amount = list[:amount]
      if balance.save
        message = "scceeded to save balance id: #{balance.id}, user: #{balance.user.name}, period: #{balance.period}"
        LoggerUtility.output_info_log({class_name: self.name, method: __method__, user: user, message: message})
      else
        message = balance.errors.full_messages
        LoggerUtility.output_info_log({class_name: self.name, method: __method__, user: user, message: message})
      end
    end
  end

  # すでにSQLを叩いて、取り出しているレコード群の中から該当する月のレコードをSQLを叩かないで取り出し、そのamountを返す。なければ、0を返す。
  # @return Integer
  def self.this_month_amount(period)
    self.find{ |balance| balance.period == period }.try(:amount) || 0
  end

  # すでにSQLを叩いて、取り出しているレコード群のamountの合計値をSQLを叩かないで取り出す。
  def self.total_amount
    self.sum{ |balance| balance.amount }
  end

end
