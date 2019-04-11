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
    password: Rails.application.credentials.dummy_user_password,
    allow_share_own: false
  )
end

User.import users

def register_partner(user, partner)
  user.update_attributes!(partner_id: partner.id)
end

ActiveRecord::Base.transaction do
  user = users[0]
  partner = users[1]
  register_partner(user, partner)
  register_partner(partner, user)
end