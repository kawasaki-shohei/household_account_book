class Expense < ApplicationRecord

  def self.ones_expenses(user, cnum)
    user.expenses.this_month.both_f.newer
  end

  def self.expense_in_both_one_month(current_user, partner, cnum)
    end_of_one_month = Date.today.months_ago(cnum).end_of_month
    begging_of_one_month = Date.today.months_ago(cnum).beginning_of_month
    current_user.expenses.which_month(begging_of_one_month, end_of_one_month).both_t.sum(:mypay) + partner.expenses.which_month(begging_of_one_month, end_of_one_month).both_t.sum(:partnerpay) - current_user.expenses.which_month(begging_of_one_month, end_of_one_month).both_t.sum(:amount)
  end

  def self.past_and_future(beginning_of_month, end_of_month)
    # 自分一人の出費
    @current_user_expenses = current_user.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_f.newer

    # 二人の出費の内、自分が払うもの、上記との違いはboth_flgのみ
    @current_user_expenses_of_both = current_user.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_t.newer

    # 相手が記入した二人の出費の内、自分が払うもの
    @partner_expenses_of_both = partner.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_t.newer
    common_variables(@current_user_expenses, @current_user_expenses_of_both, @partner_expenses_of_both)
  end

  def self.which_month_expense(cnum)
    if cnum < 0
      beginning_of_month = Date.today.months_ago(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_ago(@cnum.abs).end_of_month
    elsif cnum == 0
      redirect_to expenses_path
    elsif cnum > 0
      beginning_of_month = Date.today.months_since(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_since(@cnum.abs).end_of_month
    end
    past_and_future(beginning_of_month, end_of_month)
  end

end
