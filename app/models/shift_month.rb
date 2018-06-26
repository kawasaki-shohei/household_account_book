class ShiftMonth < ApplicationRecord

  # def self.ones_expenses(user, cnum)
  #   begging_of_one_month = which_month_expense(cnum)[0]
  #   end_of_one_month = which_month_expense(cnum)[1]
  #   user.expenses.one_month(begging_of_one_month, end_of_one_month).both_f.newer
  # end

  def self.ones_expenses(user, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    user.expenses.one_month(begging_of_one_month, end_of_one_month)
  end

  def self.ones_expenses_of_both(user, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    user.expenses.one_month(begging_of_one_month, end_of_one_month).both_t.newer
  end

  def self.must_pay_one_month(current_user, partner, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    current_user.expenses.one_month(begging_of_one_month, end_of_one_month).both_t.sum(:mypay) + partner.expenses.one_month(begging_of_one_month, end_of_one_month).both_t.sum(:partnerpay)
  end

  def self.must_pay_one_month_one_category(current_user, partner, cnum, category)
    begging_of_one_month = which_month_expense(cnum)[0]
    end_of_one_month = which_month_expense(cnum)[1]
    current_user.expenses.one_month(begging_of_one_month, end_of_one_month).category(category.id).both_t.sum(:mypay) + partner.expenses.one_month(begging_of_one_month, end_of_one_month).category(category.id).both_t.sum(:partnerpay)
  end

  def self.which_month_expense(cnum)
    if cnum < 0
      beginning_of_one_month = Date.today.months_ago(cnum.abs).beginning_of_month
      end_of_one_month = Date.today.months_ago(cnum.abs).end_of_month
    else
      beginning_of_one_month = Date.today.months_since(cnum.abs).beginning_of_month
      end_of_one_month = Date.today.months_since(cnum.abs).end_of_month
    end
    return beginning_of_one_month, end_of_one_month
  end

end
