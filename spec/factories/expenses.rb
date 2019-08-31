# ## Schema Information
#
# Table name: `expenses`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint(8)`        | `not null, primary key`
# **`amount`**             | `integer`          |
# **`date`**               | `date`             |
# **`is_for_both`**        | `boolean`          | `default(FALSE)`
# **`memo`**               | `string`           |
# **`mypay`**              | `integer`          |
# **`partnerpay`**         | `integer`          |
# **`percent`**            | `integer`          | `default("pay_all"), not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`category_id`**        | `integer`          |
# **`repeat_expense_id`**  | `bigint(8)`        |
# **`user_id`**            | `integer`          |
#
# ### Indexes
#
# * `index_expenses_on_repeat_expense_id`:
#     * **`repeat_expense_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`repeat_expense_id => repeat_expenses.id`**
#

FactoryBot.define do
  factory :own_expense, class: 'Expense' do
    amount { Faker::Number.number(digits: 6) }
    date { Faker::Date.backward(days: 365) }
    memo { Faker::Lorem.word }
    association :user, strategy: :build
    association :category, factory: :own_category, strategy: :build

    factory :own_this_month_expense, class: 'Expense' do
      date { Faker::Date.between(from: Date.current.beginning_of_month, to: Date.current.end_of_month) }
    end

    factory :own_last_month_expense, class: 'Expense' do
      date { Faker::Date.between(from: Date.current.last_month.beginning_of_month, to: Date.current.last_month.end_of_month) }
    end
  end

  factory :own_both_expenses, class: 'Expense' do
    is_for_both { true }
    date { Faker::Date.backward(days: 365) }
    amount { Faker::Number.number(digits: 6) }
    association :user, strategy: :build
    association :category, factory: :both_category, strategy: :build

    trait :with_exist_category do
      category { user.categories.where(is_common: true).sample }
    end

    trait :for_this_month do
      date { Faker::Date.between(from: Date.current.beginning_of_month, to: Date.current.end_of_month) }
    end

    trait :for_last_month do
      date { Faker::Date.between(from: Date.current.last_month.beginning_of_month, to: Date.current.last_month.end_of_month) }
    end

    trait :for_past_day_before_last_month do
      date { Faker::Date.between(from: Date.current.last_year.beginning_of_month, to: Date.current.months_ago(2).end_of_month) }
    end

    factory :own_both_manual_amount_expense, class: 'Expense' do
      amount { 5000 }
      percent { "manual_amount" }
      mypay { 1000 }
      partnerpay { 4000 }
    end

    factory :own_both_pay_all_expense, class: 'Expense' do
      amount { 1000 }
      percent { "pay_all" }
    end

    factory :own_both_pay_half_expense, class: 'Expense' do
      amount { 8000 }
      percent { "pay_half" }
    end

    factory :own_both_pay_one_third_expense, class: 'Expense' do
      amount { 3000 }
      percent { "pay_one_third" }
    end

    factory :own_both_pay_two_third_expense, class: 'Expense' do
      amount { 3000 }
      percent { "pay_two_thirds" }
    end

    factory :own_both_pay_nothing_expense, class: 'Expense' do
      amount { 2000 }
      percent { "pay_nothing" }
    end
    
    # パートナーの出費
    factory :partner_both_manual_amount_expense, class: 'Expense' do
      amount { 10000 }
      percent { "manual_amount" }
      mypay { 2000 }
      partnerpay { 8000 }
    end

    factory :partner_both_pay_all_expense, class: 'Expense' do
      amount { 2000 }
      percent { "pay_all" }
    end

    factory :partner_both_pay_half_expense, class: 'Expense' do
      amount { 16000 }
      percent { "pay_half" }
    end

    factory :partner_both_pay_one_third_expense, class: 'Expense' do
      amount { 6000 }
      percent { "pay_one_third" }
    end

    factory :partner_both_pay_two_third_expense, class: 'Expense' do
      amount { 6000 }
      percent { "pay_two_thirds" }
    end

    factory :partner_both_pay_nothing_expense, class: 'Expense' do
      amount { 4000 }
      percent { "pay_nothing" }
    end
  end

  factory :partner_both_expenses, class: 'Expense' do
    association :user, strategy: :build
    association :category, factory: :both_category, strategy: :build
  end
end
