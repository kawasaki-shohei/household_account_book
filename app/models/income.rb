# ## Schema Information
#
# Table name: `incomes`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`amount`**      | `integer`          |
# **`date`**        | `date`             |
# **`memo`**        | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_incomes_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Income < ApplicationRecord
  include BalanceHelper

  belongs_to :user
  validates_presence_of :amount, :date
  validates :amount, format: { with: /[0-9]+/ }, length: { maximum: 10 }
  validates_length_of :memo, maximum: 100

  scope :one_month, -> (month) {where('date >= ? AND date <= ?', month.to_beginning_of_month, month.to_end_of_month)}
  scope :newer, -> {order(date: :desc, created_at: :desc)}

  attr_accessor :is_new, :is_destroyed, :differences
  alias_method :is_new?, :is_new
  alias_method :is_destroyed?, :is_destroyed

  after_initialize { self.is_new = true unless self.id }
  before_save :set_differences
  before_destroy { self.is_destroyed = true }
  after_commit { go_calculate_balance(self) }

  # 該当付きの収入の合計値を算出
  def self.one_month_total_income(user, month)
    user.incomes.one_month(month).sum(:amount)
  end

  # 金額に関するカラムを配列で返す。
  def self.money_attributes
    %w(amount)
  end

  # すでにSQLを叩いて、取り出しているレコード群のamountの合計値をSQLを叩かないで取り出す。
  def self.total_amount
    self.sum{ |income| income.amount }
  end
end
