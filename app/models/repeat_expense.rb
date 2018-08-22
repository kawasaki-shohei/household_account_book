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
# **`mypay`**        | `integer`          |
# **`note`**         | `string`           |
# **`partnerpay`**   | `integer`          |
# **`percent`**      | `integer`          |
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
  belongs_to :category
  belongs_to :user
  has_many :expenses, dependent: :destroy

  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(updated_at: :desc)}

  def self.ones_expenses(user)
    user.repeat_expenses.both_f.newer
  end

  def self.ones_expenses_of_both(user)
    user.repeat_expenses.both_t.newer
  end

  def self.arrange(both_flg)
    both_flg ? self.both_t.newer : self.both_f.newer
  end
end
