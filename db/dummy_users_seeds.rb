tables = ['users', 'partners']
tables.each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

users = []
1.upto 2 do |i|
  users << User.new(
    id: i,
    name: "test-user#{i}",
    email: "user#{i}@gmail.com",
    password: ENV['DUMMY_USERS_PASSWORD'],
    password_confirmation: ENV['DUMMY_USERS_PASSWORD'],
    allow_share_own: false
  )
end

User.import users

user = users[0]
partner = users[1]
@partners = []

def make_partner(user, partner)
  @partners << Partner.new(
    user_id: user.id,
    partner_id: partner.id
  )
end

make_partner(user, partner)
make_partner(partner, user)
Partner.import @partners