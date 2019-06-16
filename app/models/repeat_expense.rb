# ## Schema Information
#
# Table name: `repeat_expenses`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint(8)`        | `not null, primary key`
# **`amount`**       | `integer`          |
# **`both_flg`**     | `boolean`          | `default(FALSE)`
# **`e_date`**       | `date`             |
# **`memo`**         | `string`           |
# **`mypay`**        | `integer`          |
# **`partnerpay`**   | `integer`          |
# **`percent`**      | `integer`          | `not null`
# **`r_date`**       | `integer`          |
# **`s_date`**       | `date`             |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`category_id`**  | `bigint(8)`        |
# **`user_id`**      | `bigint(8)`        |
#
# ### Indexes
#
# * `index_repeat_expenses_on_category_id`:
#     * **`category_id`**
# * `index_repeat_expenses_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`category_id => categories.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class RepeatExpense < ApplicationRecord
  include PercentCalculator

  enum percent: { manual_amount: -1, pay_all: 0, pay_half: 1, pay_one_third: 2, pay_two_thirds: 3, pay_nothing: 4 }

  belongs_to :category
  belongs_to :user
  has_many :expenses, dependent: :destroy

  before_validation :set_mypay_and_partnerpay

  validates :amount, :s_date, :e_date, :r_date, :percent,presence: true
  validates_length_of :amount, :mypay, :partnerpay, maximum: 10
  validates_length_of :memo, maximum: 100
  validate :calculate_amount
  validate :e_date_is_over_first_date

  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(updated_at: :desc)}

  alias_attribute :is_for_both?, :both_flg

  def self.ones_expenses(user)
    user.repeat_expenses.both_f.newer
  end

  def self.ones_expenses_of_both(user)
    user.repeat_expenses.both_t.newer
  end

  def self.arrange(both_flg)
    both_flg ? self.both_t.newer : self.both_f.newer
  end

  def e_date_is_over_first_date
    first_date = s_date.next_nth_day(r_date)
    if e_date < first_date + 1.month
      errors[:base] << "終了日は初回の出費の日付より1ヶ月後以降（#{I18n.l(first_date + 1.month + 1.day, format: :default)}〜）にしてください。"
    end
  end

  def is_own_expense?(user, category=self.category)
    !is_for_both? && self.user == user && self.category == category
  end
end
