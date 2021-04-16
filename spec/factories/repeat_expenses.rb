# ## Schema Information
#
# Table name: `repeat_expenses`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint(8)`        | `not null, primary key`
# **`amount`**          | `integer`          |
# **`deleted_at`**      | `datetime`         |
# **`end_date`**        | `date`             |
# **`is_for_both`**     | `boolean`          | `default(FALSE)`
# **`memo`**            | `string`           |
# **`mypay`**           | `integer`          |
# **`partnerpay`**      | `integer`          |
# **`percent`**         | `integer`          | `default("pay_all"), not null`
# **`repeat_day`**      | `integer`          |
# **`start_date`**      | `date`             |
# **`updated_period`**  | `integer`          | `default("first_item"), not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`category_id`**     | `bigint(8)`        |
# **`item_id`**         | `integer`          | `not null`
# **`item_sub_id`**     | `integer`          | `not null`
# **`user_id`**         | `bigint(8)`        |
#
# ### Indexes
#
# * `index_repeat_expenses_on_category_id`:
#     * **`category_id`**
# * `index_repeat_expenses_on_deleted_at`:
#     * **`deleted_at`**
# * `index_repeat_expenses_on_user_id`:
#     * **`user_id`**
# * `index_repeat_expenses_on_user_id_and_item_id_and_item_sub_id` (_unique_):
#     * **`user_id`**
#     * **`item_id`**
#     * **`item_sub_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`category_id => categories.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

FactoryBot.define do
  factory :repeat_expense do
    amount { Faker::Number.number(digits: 6) }
    start_date { Faker::Date.between(from: 3.months.ago, to: 2.months.ago) }
    end_date { Faker::Date.between(from: 3.months.since, to: 2.months.since) }
    repeat_day { [*1..28].sample }
    memo { Faker::Lorem.word }
    is_for_both { false }
    sequence(:item_id)
    item_sub_id { 1 }
    association :user, strategy: :build
    association :category, factory: :own_category, strategy: :build
  end
end
