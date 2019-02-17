FactoryBot.define do
  factory :category do
    kind {"食費"}
    user {User.first}
  end
end
