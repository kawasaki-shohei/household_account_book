class ShiftMonth < ApplicationRecord

  def self.ones_expenses(user, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    user.expenses.one_month(begging_of_one_month, end_of_one_month).both_f.newer
  end

  def self.ones_expenses_of_both(user, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    user.expenses.one_month(begging_of_one_month, end_of_one_month).both_t.newer
  end

  def self.partner_expenses_of_both(partner, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    partner.expenses.one_month(begging_of_one_month, end_of_one_month).both_t.newer
  end

  def self.must_pay_this_month(current_user, partner, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    current_user.expenses.one_month(begging_of_one_month, end_of_one_month).both_t.sum(:mypay) + partner.expenses.one_month(begging_of_one_month, end_of_one_month).both_t.sum(:partnerpay)
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
      beginning_of_one_month = Date.today.months_ago(cnum.abs).beginning_of_month
      end_of_one_month = Date.today.months_ago(cnum.abs).end_of_month
    elsif cnum > 0
      beginning_of_one_month = Date.today.months_since(cnum.abs).beginning_of_month
      end_of_one_month = Date.today.months_since(cnum.abs).end_of_month
    end
    return beginning_of_one_month, end_of_one_month
  end

end
