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
# **`is_preview_user`**  | `boolean`          | `default(FALSE)`
# **`name`**             | `string`           |
# **`password_digest`**  | `string`           |
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_users_on_email` (_unique_):
#     * **`email`**
#

FactoryBot.define do
  factory :user, class: 'User' do
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

      trait :with_this_and_last_expenses do
        after(:create) do |user|
          create_list(:both_category, 5, user: user)
          # 今月分
          create_list(:own_both_manual_amount_expense, 5, :for_this_month, :with_exist_category, user: user)
          create_list(:own_both_pay_all_expense, 5, :for_this_month, :with_exist_category, user: user)
          create_list(:own_both_pay_half_expense, 5, :for_this_month, :with_exist_category, user: user)
          create_list(:own_both_pay_one_third_expense, 5, :for_this_month, :with_exist_category, user: user)
          create_list(:own_both_pay_two_third_expense, 5, :for_this_month, :with_exist_category, user: user)
          create_list(:own_both_pay_nothing_expense, 5, :for_this_month, :with_exist_category, user: user)
          # 先月分
          create_list(:own_both_manual_amount_expense, 5, :for_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_all_expense, 5, :for_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_half_expense, 5, :for_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_one_third_expense, 5, :for_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_two_third_expense, 5, :for_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_nothing_expense, 5, :for_last_month, :with_exist_category, user: user)
        end
      end

      trait :with_expenses_before_last_month do
        after(:create) do |user|
          create_list(:both_category, 5, user: user)
          create_list(:own_both_manual_amount_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_all_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_half_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_one_third_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_two_third_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: user)
          create_list(:own_both_pay_nothing_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: user)
        end
      end

      trait :with_partner_this_and_last_expenses do
        after(:create) do |user|
          partner = user.partner
          create_list(:both_category, 5, user: partner)
          # 今月分
          create_list(:partner_both_manual_amount_expense, 5, :for_this_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_all_expense, 5, :for_this_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_half_expense, 5, :for_this_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_one_third_expense, 5, :for_this_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_two_third_expense, 5, :for_this_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_nothing_expense, 5, :for_this_month, :with_exist_category, user: partner)
          # 先月分
          create_list(:partner_both_manual_amount_expense, 5, :for_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_all_expense, 5, :for_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_half_expense, 5, :for_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_one_third_expense, 5, :for_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_two_third_expense, 5, :for_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_nothing_expense, 5, :for_last_month, :with_exist_category, user: partner)
        end
      end

      trait :with_partner_expenses_before_last_month do
        after(:create) do |user|
          partner = user.partner
          create_list(:both_category, 5, user: partner)
          create_list(:partner_both_manual_amount_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_all_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_half_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_one_third_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_two_third_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: partner)
          create_list(:partner_both_pay_nothing_expense, 5, :for_past_day_before_last_month, :with_exist_category, user: partner)
        end
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
