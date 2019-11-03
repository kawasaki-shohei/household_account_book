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
# **`date`**          | `date`             | `not null`
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

FactoryBot.define do
  factory :deposit do
    amount { 10000 }
    date { Date.current }
    is_withdrawn { false }
    association :user, strategy: :build

    trait :withdrawn do
      amount { -10000 }
      is_withdrawn { true }
    end
  end


end
