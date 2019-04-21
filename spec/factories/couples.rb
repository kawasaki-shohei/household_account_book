# ## Schema Information
#
# Table name: `couples`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`partner_id`**  | `bigint(8)`        |
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_couples_on_partner_id` (_unique_):
#     * **`partner_id`**
# * `index_couples_on_user_id` (_unique_):
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`partner_id => users.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

FactoryBot.define do
  factory :couple do
    
  end
end
