FactoryBot.define do
  factory :pay do
    amount { Faker::Number.number(6) }
    date { Faker::Date.backward(365) }
    association :user, strategy: :build
  end
end
