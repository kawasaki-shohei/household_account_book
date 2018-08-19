module UsersHelper
  include SessionsHelper
  def partner
    @partner ||= current_user.partner
end

  def have_partner?
    !partner.nil?
  end

  def check_partner
    unless have_partner?
      redirect_to user_path(current_user)
    end
  end

  # パートナーが誰かを調べるもの。出費リストの表示でパートナーのパートナーを表示するため。
  def who_is_partner(user)
    user.partner
  end

  def display_name(user_id)
    User.find(user_id)
  end
end
