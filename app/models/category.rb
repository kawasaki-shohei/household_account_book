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

  validates :kind, presence: true, length: { maximum: 15 }

  def self.ones_categories(user)
    partner = user.partner
    user.categories.or(partner.categories.common_t).order(:id)
  end

  # @note userが使っているカテゴリーを予算と一緒に取得
  def self.available_categories_with_badgets(user)
    partner = user.partner
    self.includes(:user, badgets: :user).where(users: {id: [user, partner]}).order(id: :asc)
  end

  # @param [User] current_user
  # @param [User] partner
  # @return [Category::ActiveRecord_AssociationRelation]
  def self.get_user_categories_with_badgets(user)
    partner = user.partner
    user.categories.or(partner.categories.common_t).includes(badgets: :user).where(badgets: {user: [user, nil]}).order(:id)
  end

    # @return [Badget]
  # @note すでに取得しているactiverecord collectionsからsqlを叩かないで、そのユーザーのbadgetを取得する。
  def user_badget(user)
    badgets.find{ |badget| badget.try(:user_id) == user.id }
  end

  # @return
  def only_ones_own?(user)
    self.user == user && !common
  end

end
