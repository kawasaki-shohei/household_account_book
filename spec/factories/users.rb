FactoryBot.define do
  factory :user do
    email {"user@gmail.com"}
    name {"user"}
    password {"000000"}
    password_confirmation {"000000"}
  end

  # 以下ではパートナーは作れない。
  # factory :partner do
  #   email {"partner@gmail.com"}
  #   name {"partner"}
  #   password {"000000"}
  #   password_confirmation {"000000"}
  #   partner {User.first}
  # end
end
