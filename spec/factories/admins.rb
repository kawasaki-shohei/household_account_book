# ## Schema Information
#
# Table name: `admins`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint(8)`        | `not null, primary key`
# **`email`**            | `string`           | `not null`
# **`name`**             | `string`           | `not null`
# **`password_digest`**  | `string`           | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_admins_on_email` (_unique_):
#     * **`email`**
#

FactoryBot.define do
  factory :admin do
    name { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
  end
end
