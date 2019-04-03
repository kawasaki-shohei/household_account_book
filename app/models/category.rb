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

  # @param [User] current_user
  # @param [User] partner
  # @return categories.*, category.badget_id, category.badget_user_id, category.badget_amount,
  # @note current_userのカテゴリーとパートナーが共通カテゴリー登録しているものを取得し、badgetsをleft outer joinしている。current_userがまだ登録していない場合があるため、パートナーのbadgetsも取得する。
  # @note where.not(badgets: {user: partner}) にするとbadget_user_idがnilのものが取得できなかった。
  def self.get_user_categories_with_badgets(current_user, partner)
    current_user.categories.or(partner.categories.common_t).includes(:badgets).where(badgets: {user: [current_user, partner, nil]}).order(:id)
  end
end
