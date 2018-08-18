class PaysController < ApplicationController
  before_action :set_pay, only:[:edit, :update, :destroy]
  after_action -> {create_notification(@pay)}, only: [:create, :update]

  def index
    @pays = Pay.all_payments(current_user, partner)
    @balance = Pay.balance_of_gross(current_user, partner)
    @my_payment = Expense.both_this_month(current_user, partner)
    @my_last_payment = Expense.both_last_month(current_user, partner)
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

  def update
    if @pay.update(pay_params)
      redirect_to pays_path, notice: "#{@pay.date.strftime("%Y年%m月")}分の手渡し料金を編集しました。"
    else
      render 'edit'
    end
  end

  def destroy
    create_notification(@pay)
    @pay.destroy
    redirect_to pays_path, notice: "手渡し料金を削除しました。"
  end


  private
    def pay_params
      params.require(:pay).permit(:pamount, :date, :memo).merge(user_id: current_user.id)
    end

    def set_pay
      @pay = Pay.find(params[:id])
    end
end
