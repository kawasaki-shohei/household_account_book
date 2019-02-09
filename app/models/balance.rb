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
# **`month`**       | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_balances_on_user_id`:
#     * **`user_id`**
# * `index_balances_on_user_id_and_month` (_unique_):
#     * **`user_id`**
#     * **`month`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Balance < ApplicationRecord
  belongs_to :user
  validates :month, uniqueness: { scope: :user_id }, format: { with: /\A\d{4}-\d{2}\z/ }

  # 当月の総支出を計算して、支出バランスを計算し直し、balanceのレコードを更新するメソッド
  def self.create_or_update_balance(object)
    return if object.skip_calculate_balance
    target_month = object.date.month_as_string
    user = object.user
    partner = user.partner
    user_balance = set_balance(user, target_month)
    if user_balance.save! && object.is_a?(Expense) && object.both_flg
      partner_balance = set_balance(partner, target_month)
      partner_balance.save!
    end
    raise Exception.new(StandardError) # FIXME: 必ず削除
  end

  def self.set_balance(user, target_month)
    balance = user.get_applicable_balance(target_month)
    # amountの算出
    # 収入額 - 支出合計額
    balance.amount = Income.one_month_total_income(user, target_month) - Expense.one_month_total_expenditures(user, target_month)
    balance
  end
end
