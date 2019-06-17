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
#
# ### Indexes
#
# * `index_users_on_email` (_unique_):
#     * **`email`**
#

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    factory :user_with_partner, class: 'User' do
      after(:create) do |user|
        partner = create(:partner)
        create(:couple, user: user, partner: partner)
        create(:couple, user: partner, partner: user)
      end
    end
  end

  factory :partner, class: 'User' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password {"password"}
    password_confirmation {"password"}
  end
end
