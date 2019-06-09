tables = %w(users)
tables.each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

def create_two_users(id=0)
  users = []
  2.times do
    id += 1
    users << User.create!(
      name: "test-user#{id}",
      email: "user#{id}@gmail.com",
      password: Rails.application.credentials.dummy_user_password
    )
  end
  users
end

def make_one_couple(user, partner)
  user.update_attributes!(partner_id: partner.id)
  partner.update_attributes!(partner_id: user.id)
end

ActiveRecord::Base.transaction do
  user, partner = create_two_users
  make_one_couple(user, partner)
end