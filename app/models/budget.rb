# ## Schema Information
#
# Table name: `budgets`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint(8)`        | `not null, primary key`
# **`amount`**       | `integer`          |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`category_id`**  | `bigint(8)`        |
# **`user_id`**      | `bigint(8)`        |
#
# ### Indexes
#
# * `index_budgets_on_category_id`:
#     * **`category_id`**
# * `index_budgets_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`category_id => categories.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates_presence_of :amount
  validate :must_not_set_multiple_budgets_for_one_category, on: :create
  def must_not_set_multiple_budgets_for_one_category
    if Budget.exists?(user: self.user, category: self.category)
      errors[:base] << I18n.t('budget.validation.no_multiple_records')
    end
  end
end
