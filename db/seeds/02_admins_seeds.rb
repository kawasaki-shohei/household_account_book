Admin.create!(
  id: 1,
  name: '管理者',
  email: 'admin@gmail.com',
  password: Rails.application.credentials.admin_user_password
)