class ShiftMonthsController < ApplicationController
  def past
    @cnum = params[:id].to_i - 1
    @current_user_expenses = ShiftMonth.ones_expenses(user, cnum)
    @current_user_expenses_of_both
    @partner_expenses_of_both
    @sum
    @both_sum
    @category_badgets
    if @cnum < 0
      beginning_of_month = Date.today.months_ago(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_ago(@cnum.abs).end_of_month
    elsif @cnum == 0
      redirect_to expenses_path
    elsif @cnum > 0
      beginning_of_month = Date.today.months_since(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_since(@cnum.abs).end_of_month
    end
    past_and_future(beginning_of_month, end_of_month)
  end

  def future
    @cnum = params[:id].to_i + 1
    if @cnum < 0
      beginning_of_month = Date.today.months_ago(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_ago(@cnum.abs).end_of_month
    elsif @cnum == 0
      redirect_to expenses_path
    elsif @cnum > 0
      beginning_of_month = Date.today.months_since(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_since(@cnum.abs).end_of_month
    end
    past_and_future(beginning_of_month, end_of_month)
  end

  def past_and_future(beginning_of_month, end_of_month)
      # 自分一人の出費
      @current_user_expenses = current_user.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_f.newer

      # 二人の出費の内、自分が払うもの、上記との違いはboth_flgのみ
      @current_user_expenses_of_both = current_user.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_t.newer

      # 相手が記入した二人の出費の内、自分が払うもの
      @partner_expenses_of_both = partner.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_t.newer
      common_variables(@current_user_expenses, @current_user_expenses_of_both, @partner_expenses_of_both)
    end
end
