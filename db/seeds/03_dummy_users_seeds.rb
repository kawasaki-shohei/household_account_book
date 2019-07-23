tables = %w(users)
tables.each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

def create_two_users
  users = []
  id = User.maximum(:id) + 1
  2.times do
    id += 1
    user = User.new(
      id: id,
      name: "user#{id}",
      email: "user#{id}@gmail.com",
      password: Rails.application.credentials.dummy_user_password
    )
    # 開発用に簡単なパスワードを設定しているため
    user.save(validate: false)
  end
end

def make_one_couple(user, partner)
  Couple.create!(user: user, partner: partner)
  Couple.create!(user: partner, partner: user)
end

ActiveRecord::Base.transaction do
  user, partner = create_two_users
  make_one_couple(user, partner)
end