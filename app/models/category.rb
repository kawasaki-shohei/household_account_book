# ## Schema Information
#
# Table name: `categories`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`is_common`**   | `boolean`          | `default(FALSE)`
# **`name`**        | `string`           |
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
  has_many :budgets, dependent: :destroy
  has_many :expenses

  scope :oneself, -> {where(is_common: false)}
  scope :common_t, -> {where(is_common: true)}

  validates :name, presence: true, length: { maximum: 15 }

  def self.ones_categories(user)
    partner = user.partner
    user.categories.or(partner.categories.common_t).order(:id)
  end

  # @note userが使っているカテゴリーを予算と一緒に取得
  def self.available_categories_with_budgets(user)
    partner = user.partner
    self.includes(:user, budgets: :user).where(users: {id: [user, partner]}).order(id: :asc)
  end

  # @param [User] current_user
  # @param [User] partner
  # @return [Category::ActiveRecord_AssociationRelation]
  def self.get_user_categories_with_budgets(user)
    partner = user.partner
    user.categories.or(partner.categories.common_t).includes(budgets: :user).references(budgets: :users).order(:id)
  end

    # @return [Budget]
  # @note すでに取得しているactiverecord collectionsからsqlを叩かないで、そのユーザーのbudgetを取得する。
  def user_budget(user)
    budgets.find{ |budget| budget.try(:user) == user }
  end

  # @return
  def only_ones_own?(user)
    self.user == user && !is_common?
  end

end
