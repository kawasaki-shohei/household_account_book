module UsersHelper
  def partner(user)
    check = Partner.find_by(user_id: user.id)
    if check.present?
      @partner = User.find(check.partner_id)
    end
  end
end
