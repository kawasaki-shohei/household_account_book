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
