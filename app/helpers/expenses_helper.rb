module ExpensesHelper
  def percent_selection
    selection = { '半分' => 1, '3分の1' => 2, '3分の2' => 3, '相手100%' => 4 }
    return selection
  end

  def which_percent(val)
    percent_selection.key(val)
  end

  def who_is_partner(current_user)
    if current_user.email == "shoheimoment@gmail.com"
      @partner = User.find_by(email: "ikky629@gmail.com")
    elsif current_user.email == "ikky629@gmail.com"
      @partner = User.find_by(email: "shoheimoment@gmail.com")
    end
    return @partner
  end

end
