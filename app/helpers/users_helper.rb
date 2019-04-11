module UsersHelper

  # パートナーが誰かを調べるもの。出費リストの表示でパートナーのパートナーを表示するため。
  def who_is_partner(user)
    user.partner
  end

end
