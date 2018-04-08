class ShiftMonthsController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner

  def past
    @cnum = params[:id].to_i - 1
    redirect_to expenses_path if @cnum == 0
    past_and_future(@cnum)
  end

  def future
    @cnum = params[:id].to_i + 1
    redirect_to expenses_path if @cnum == 0
    past_and_future(@cnum)
  end

  def past_and_future(cnum)
    @current_user_expenses = ShiftMonth.ones_expenses(current_user, cnum)
    @current_user_expenses_of_both = ShiftMonth.ones_expenses_of_both(current_user, cnum)
    @partner_expenses_of_both = ShiftMonth.ones_expenses_of_both(partner, cnum)
    @sum = @current_user_expenses.sum(:amount)
    @both_sum = ShiftMonth.must_pay_this_month(current_user, partner, cnum)
    @category_badgets = current_user.badgets
  end
end
