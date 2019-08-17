tables = %w(users)
tables.each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

def create_two_users
  users = []
  id = User.first.present? ? User.maximum(:id) : 0
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
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
    users << user
  end
  users
end

def make_one_couple(user, partner)
  Couple.create!(user: user, partner: partner)
  Couple.create!(user: partner, partner: user)
end

ActiveRecord::Base.transaction do
  user, partner = create_two_users
  make_one_couple(user, partner)
end