class DepositsController < ApplicationController

  def index
    @deposits = Deposit.where(user_id: [current_user.id, partner.id]).order(date: :desc)
  end

  def new
    @deposit = current_user.deposits.build
  end

  def withdraw
    @deposit = current_user.deposits.build
  end

  def create
    @deposit = current_user.deposits.build(deposit_params)
    if @deposit.save
      redirect_to deposits_path, notice: "二人の貯金に#{@deposit.amount.to_s(:delimited)}円追加しました。"
    else
      render :new
    end
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end

  def update
    @deposit = Deposit.find(params[:id])
    if @deposit.update(deposit_params)
      redirect_to deposits_path, notice: "貯金を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @deposit = Deposit.find(params[:id])
    @deposit.destroy
    redirect_to deposits_path, notice: "貯金を削除しました。"
  end

  private
  def deposit_params
    params.require(:deposit).permit(:is_withdrawn, :amount, :date, :memo)
  end

end
