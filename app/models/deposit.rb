# ## Schema Information
#
# Table name: `deposits`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint(8)`        | `not null, primary key`
# **`amount`**        | `integer`          | `not null`
# **`date`**          | `datetime`         | `not null`
# **`is_withdrawn`**  | `boolean`          | `default(FALSE)`
# **`memo`**          | `string`           |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`user_id`**       | `bigint(8)`        |
#
# ### Indexes
#
# * `index_deposits_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Deposit < ApplicationRecord
  belongs_to :user
  validates_presence_of :amount, :date
  validates_length_of :amount, maximum: 10
  validates_length_of :memo, maximum: 100

  def self.total_amount
    self.where.not(is_withdrawn: true).sum(:amount) - self.where(is_withdrawn: true).sum(:amount)
  end
end
