module UsersHelper
  def partner
    check = Partner.find_by(user_id: current_user.id)
    if check.present?
      @partner = User.find(check.partner_id)
    end
  end
end
