# ## Schema Information
#
# Table name: `categories`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`common`**      | `boolean`          | `default(FALSE)`
# **`kind`**        | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_categories_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Category < ApplicationRecord
  belongs_to :user
  has_many :badgets, dependent: :destroy
  has_many :expenses

  scope :oneself, -> {where(common: false)}
  scope :common_t, -> {where(common: true)}

  validates :kind, presence: true

  def self.ones_categories(current_user, partner)
    current_user.categories.or(partner.categories.where(common: true))
  end
end
