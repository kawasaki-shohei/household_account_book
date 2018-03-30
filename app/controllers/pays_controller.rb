class PaysController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner
  
  def index
    partner(current_user)
    @pays = current_user.pays
    @balance = Pay.balance_of_gross(current_user, @partner)
    @my_payment = Expense.expense_in_both_this_month(current_user, @partner)
  end

  def new
    @pay = Pay.new
  end

  def create
    @pay = Pay.new(pay_params)
    @pay.save
    redirect_to pays_path, notice: "#{@pay.date.strftime("%Y年%m月")}分の手渡し料金を登録しました。"
  end

  def edit
  end

  private
    def pay_params
      params.require(:pay).permit(:pamount, :date, :memo).merge(user_id: current_user.id)
    end
end
