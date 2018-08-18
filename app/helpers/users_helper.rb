module UsersHelper
  def partner
    check = Partner.find_by(user_id: current_user.id)
    if check.present?
      @partner ||= User.find(check.partner_id)
    end
  end

  def have_partner?
    !partner.nil?
  end

  def check_partner
    unless have_partner?
      redirect_to new_partner_path
    end
  end

  # パートナーが誰かを調べるもの。出費リストの表示でパートナーのパートナーを表示するため。
  def who_is_partner(user)
    check = Partner.find_by(user_id: user.id)
    User.find(check.partner_id)
  end

  def display_name(user_id)
    user = User.find(user_id)
    return user
  end
end
