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
# **`sys_admin`**        | `boolean`          | `default(FALSE)`
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

FactoryBot.define do
  # factory :users do
  #   email "user@gmail.com"
  #   name "user"
  #   password "000000"
  #   password_confirm "000000"
  # end
  #
  # factory :partner do
  #   email "partner@gmail.com"
  #   name "partner"
  #   password "000000"
  #   password_confirm "000000"
  #   partner User.first
  # end
end