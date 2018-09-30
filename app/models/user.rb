# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint(8)`        | `not null, primary key`
# **`allow_share_own`**  | `boolean`          | `default(FALSE)`
# **`email`**            | `string`           |
# **`name`**             | `string`           |
# **`password_digest`**  | `string`           |
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`partner_id`**       | `bigint(8)`        |
#
# ### Indexes
#
# * `index_users_on_email` (_unique_):
#     * **`email`**
# * `index_users_on_partner_id` (_unique_):
#     * **`partner_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`partner_id => users.id`**
#

class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true,
                    length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :partner_id, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  belongs_to :partner, class_name: 'User', optional: true
  has_many :expenses, dependent: :destroy
  has_many :repeat_expenses, dependent: :destroy
  has_many :badgets, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :pays, dependent: :destroy
  has_many :wants, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :deposits, dependent: :destroy

end
