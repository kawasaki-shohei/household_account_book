# ## Schema Information
#
# Table name: `pays`
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
# * `index_pays_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Pay < ApplicationRecord
  belongs_to :user

  validates :amount, :date, presence: true
  validates_length_of :amount, maximum: 10
  validates_length_of :memo, maximum: 100
  validates :date, past_date: true

  scope :newer, -> { order(date: :desc, created_at: :desc) }

  def self.get_couple_pays(user, partner)
    self.includes(:user).where(users: {id: [user, partner]})
  end

end
