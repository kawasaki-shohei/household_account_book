FactoryBot.define do
  factory :budget do
    amount { 10000 }
    association :user, strategy: :build
    association :category, strategy: :build
  end
end
