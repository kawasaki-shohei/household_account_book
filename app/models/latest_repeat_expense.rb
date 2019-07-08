# ## Schema Information
#
# Table name: `latest_repeat_expenses`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint(8)`        |
# **`amount`**          | `integer`          |
# **`deleted_at`**      | `datetime`         |
# **`end_date`**        | `date`             |
# **`is_for_both`**     | `boolean`          |
# **`memo`**            | `string`           |
# **`mypay`**           | `integer`          |
# **`partnerpay`**      | `integer`          |
# **`percent`**         | `integer`          |
# **`repeat_day`**      | `integer`          |
# **`start_date`**      | `date`             |
# **`updated_period`**  | `integer`          |
# **`created_at`**      | `datetime`         |
# **`updated_at`**      | `datetime`         |
# **`category_id`**     | `bigint(8)`        |
# **`item_id`**         | `integer`          |
# **`item_sub_id`**     | `integer`          |
# **`user_id`**         | `bigint(8)`        |
#

class LatestRepeatExpense < ApplicationRecord
  include RepeatExpensesListsDisplayer

  enum percent: { manual_amount: -1, pay_all: 0, pay_half: 1, pay_one_third: 2, pay_two_thirds: 3, pay_nothing: 4 }
  enum updated_period: { first_item: 0, updated_all: 1, updated_only_future: 2 }

  belongs_to :category
  belongs_to :user
  has_many :expenses, dependent: :destroy

  def readonly?
    true
  end

end
