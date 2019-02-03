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
  belongs_to :user
  validates_presence_of :amount, :date
  validates :amount, format: { with: /[0-9]+/ }, length: { maximum: 10 }
  validates_length_of :memo, maximum: 100

  scope :one_month, -> (month) {where('date >= ? AND date <= ?', month.to_beginning_of_month, month.to_end_of_month)}

  def self.one_month_total_income(user, month)
    user.incomes.one_month(month).sum(:amount)
  end
end
