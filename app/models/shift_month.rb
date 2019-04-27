class ShiftMonth < ApplicationRecord

  # # 今月以外の月の出費を取得
  # def self.ones_expenses(user, cnum)
  #   begging_of_one_month = which_month_expense(cnum)[0]
  #   # end_of_one_month = which_month_expense(cnum)[1]
  #   month = begging_of_one_month.to_s_as_period
  #   user.expenses.one_month(year_month)
  # end
  #
  # # 今月以外の月の収入を取得
  # def self.ones_incomes(user, cnum)
  #   begging_of_one_month = which_month_expense(cnum)[0]
  #   month = begging_of_one_month.to_s_as_period
  #   user.incomes.one_month(year_month)
  # end
  #
  # def self.which_month_expense(cnum)
  #   if cnum < 0
  #     beginning_of_one_month = Date.today.months_ago(cnum.abs).beginning_of_month
  #     end_of_one_month = Date.today.months_ago(cnum.abs).end_of_month
  #   else
  #     beginning_of_one_month = Date.today.months_since(cnum.abs).beginning_of_month
  #     end_of_one_month = Date.today.months_since(cnum.abs).end_of_month
  #   end
  #   return beginning_of_one_month, end_of_one_month
  # end

end
