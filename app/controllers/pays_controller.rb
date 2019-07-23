class PaysController < ApplicationController
  after_action -> {create_notification(@pay)}, only: [:create, :update]

  def index
    all_pays = Pay.get_couple_pays(@current_user, @partner)
    expenses = Expense.both_expenses_until_one_month(@current_user, @partner)
    service = CalculateRolloverService.new(@current_user, @partner, all_pays, expenses)

    @pays = all_pays.newer.page(params[:page])
    @rollover = service.call
    @own_this_month_payment, @own_last_month_payment = Expense.own_payment_for_this_and_last_month(@current_user, @partner, expenses)
  end

  def new
    @pay = Pay.new
  end

  def create
    @pay = Pay.new(pay_params)
    if @pay.save
      redirect_to pays_path, notice: "#{@pay.date.strftime("%Y年%m月")}分の手渡し料金を登録しました。"
    else
      render 'new'
    end
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
