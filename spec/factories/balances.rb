FactoryBot.define do
  factory :balance do
    amount { Faker::Number.number(digits: 6) }
    period { Date.current.to_s_as_period }
    association :user, strategy: :build
  end
end
