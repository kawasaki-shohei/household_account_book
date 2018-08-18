# 出費一覧・入力画面で使うヘルパー
module ExpensesHelper
  # 出費入力のときに割合の選択肢
  def percent_selection
    selection = { '半分' => 1, '3分の1' => 2, '3分の2' => 3, '相手100%' => 4 }
    return selection
  end

  def which_percent(val)
    percent_selection.key(val)
  end

  # 確認画面へ遷移させるかどうかを振り分けるメソッド
  def choose_new_or_edit
    if controller.controller_name == 'expenses'
      if action_name == 'new' || action_name == 'both' || action_name == 'confirm'
        confirm_expenses_path
      elsif action_name == 'edit'
        expense_path
      end
    end
    if controller.controller_name == 'repeat_expenses'
      if action_name == 'new' || action_name == 'both' || action_name == 'confirm'
        confirm_repeat_expenses_path
      elsif action_name == 'edit'
        repeat_expense_path
      end
    end
  end

  # 確認画面でコントローラによって送り先を変更するもの
  def back_new_or_both(expense)
    if controller.controller_name == 'expenses'
      return expense.both_flg ? both_expenses_path : new_expense_path
    end
    if controller.controller_name == 'repeat_expenses'
      return expense.both_flg ? both_repeat_expenses_path : new_repeat_expense_path
    end
  end

  # 出費リストのリンクをコントローラによって変更するもの
  def edit_link(expense)
    if controller.controller_name == 'expenses' || controller.controller_name == 'shift_months'
      edit_expense_path(expense.id)
    elsif controller.controller_name == 'repeat_expenses'
      edit_repeat_expense_path(expense.id)
    end
  end

  # 合計値の計算
  def both_sum(current_user_expenses, partner_expenses)
    current_user_expenses.both_t.sum(:mypay) + partner_expenses.sum(:partnerpay)
  end

  # 合計値の計算
  def mine_sum(user_expenses)
    user_expenses.both_f.sum(:amount)
  end

  # 支出合計の計算
  def one_total_expenditures(current_user_expenses, partner_expenses)
    current_user_expenses.both_f.sum(:amount) + current_user_expenses.both_t.sum(:mypay) + partner_expenses.sum(:partnerpay)
  end

  # カテゴリ別予算残高の表示順を指定する
  def ordered_badget(user)
    user.badgets.order(category_id: :asc)
  end

  # カテゴリ別支出合計を計算
  def category_sums(user_expenses, partner_expenses)
    category_ids = (user_expenses + partner_expenses).map{|i| i.category_id}
    if category_ids.present? && category_ids.size > 2 && (category_ids.count - category_ids.uniq.count) > 0
      category_ids.uniq!.sort!
    elsif category_ids.present?
      category_ids.sort!
    end
    category_sums = Hash.new
    category_ids.each do |category_id|
      category_sum = user_expenses.both_f.where(category_id: category_id).sum(:amount) + user_expenses.both_t.where(category_id: category_id).sum(:mypay) + partner_expenses.where(category_id: category_id).sum(:partnerpay)
      category_sums[category_id] = category_sum
    end
    category_sums
  end

  # カテゴリ別予算残高の計算
  def category_balance(badget, category, user_expenses, partner_expenses)
    # そのカテゴリの自分の出費の合計
    user_category_expenses_sum = user_expenses.both_f.where(category_id: category.id).sum(:amount)
    # 二人の出費の内、そのカテゴリの自分の払う金額の合計
    mypays_sum_of_both = user_expenses.both_t.where(category_id: category.id).sum(:mypay)
    # 相手が記入した二人の出費の内、そのカテゴリの自分の払う金額の合計
    partnerpays_sum_of_both = partner_expenses.where(category_id: category.id).sum(:partnerpay)
    badget.amount.to_i - user_category_expenses_sum - mypays_sum_of_both - partnerpays_sum_of_both
  end

end
