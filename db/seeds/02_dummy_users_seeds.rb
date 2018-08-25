tables = %w(users, partners)
tables.each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

users = []
2.times do |i|
  i += 1
  users << User.new(
    name: "test-user#{i}",
    email: "user#{i}@gmail.com",
    password: Settings.dummy_users_password,
    password_confirmation: Settings.dummy_users_password,
    allow_share_own: false
  )
end

User.import users

def register_partner(user, partner)
  user.assign_attributes(partner_id: partner.id)
  user.password = Settings.dummy_users_password
  user.save
end

user = users[0]
partner = users[1]
register_partner(user, partner)
register_partner(partner, user)