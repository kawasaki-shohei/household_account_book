class PaysController < ApplicationController
  after_action -> {create_notification(@pay)}, only: [:create, :update]

  def index
    @pays = Pay.get_couple_pays(current_user).page(params[:page])
    @balance = Pay.balance_of_gross(current_user, partner)
    @my_payment = Expense.both_one_month(@current_user, Date.current.to_s_as_period)
    @my_last_payment = Expense.both_one_month(@current_user, Date.current.last_month.to_s_as_period)
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
    @pay = Pay.find(params[:id])
  end

  def update
    @pay = Pay.find(params[:id])
    if @pay.update(pay_params)
      redirect_to pays_path, notice: "#{@pay.date.strftime("%Y年%m月")}分の手渡し料金を編集しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @pay = Pay.find(params[:id])
    create_notification(@pay)
    @pay.destroy
    redirect_to pays_path, notice: "手渡し料金を削除しました。"
  end


  private
    def pay_params
      params.require(:pay).permit(:amount, :date, :memo).merge(user_id: current_user.id)
    end
end
