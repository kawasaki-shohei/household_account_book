class ShiftMonthsController < ApplicationController

  def past
    @cnum = params[:id].to_i - 1
    if @cnum == 0
      redirect_to expenses_path
    else
      @current_user_expenses = ShiftMonth.ones_expenses(current_user, @cnum)
      @partner_expenses = ShiftMonth.ones_expenses(partner, @cnum)
      render 'expenses/index'
    end
  end

  def future
    @cnum = params[:id].to_i + 1
    if @cnum == 0
      redirect_to expenses_path
    else
      @current_user_expenses = ShiftMonth.ones_expenses(current_user, @cnum)
      @partner_expenses = ShiftMonth.ones_expenses(partner, @cnum)
      render 'expenses/index'
    end
  end
end
