module ExpensesHelper
  def percent_selection
    selection = { '半分' => 1, '3分の1' => 2, '3分の2' => 3, '相手100%' => 4 }
    return selection
  end

  def which_percent(val)
    percent_selection.key(val)
  end

  def choose_new_or_edit
    if controller.controller_name == 'expenses'
      if action_name == 'new' || action_name == 'both' || action_name == 'confirm'
        url = confirm_expenses_path
      elsif action_name == 'edit'
        url = expense_path
      end
    end
    if controller.controller_name == 'repeat_expenses'
      if action_name == 'new' || action_name == 'both' || action_name == 'confirm'
        url = confirm_repeat_expenses_path
      elsif action_name == 'edit'
        url = repeat_expense_path
      end
    end
    return url
  end

  def back_new_or_both(expense)
    if controller.controller_name == 'expenses'
      if expense.both_flg == true
        url = both_expenses_path
      else
        url = new_expense_path
      end
    end
    if controller.controller_name == 'repeat_expenses'
      if expense.both_flg == true
        url = both_repeat_expenses_path
      else
        url = new_repeat_expense_path
      end
    end
    return url
  end

  def category_balance(badget, category, current_user_expenses, current_user_expenses_of_both, partner_expenses_of_both)
    # そのカテゴリの自分の出費の合計
    current_user_category_expenses_sum = current_user_expenses.where(category_id: category.id).sum(:amount)
    # 二人の出費の内、そのカテゴリの自分の払う金額の合計
    mypays_sum_of_both = current_user_expenses_of_both.where(category_id: category.id).sum(:mypay)
    # 相手が記入した二人の出費の内、そのカテゴリの自分の払う金額の合計
    partnerpays_sum_of_both = partner_expenses_of_both.where(category_id: category.id).sum(:partnerpay)
    balance = badget.amount.to_i - current_user_category_expenses_sum - mypays_sum_of_both - partnerpays_sum_of_both
    return balance
  end

end
