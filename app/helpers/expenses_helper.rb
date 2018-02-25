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

  def category_balance(badget)
    sum_expense = Expense.where(user_id: current_userid, category_id: badget.category_id).sum(:amount)
    balance = badget.amount.to_i - sum_expense
    return balance
  end

end
