class ShiftMonth < ApplicationRecord

  def self.ones_expenses(user, cnum)
    begging_of_one_month = which_month_expense(cnum)[0]
    # end_of_one_month = which_month_expense(cnum)[1]
    # TODO: 前後月のルーティングパスを変更するときに修正
    month = begging_of_one_month.month_as_string
    user.expenses.one_month(month)
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
