class DepositsController < ApplicationController
  before_action :set_deposit, only: [:edit, :update, :destroy]

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
  end

  def update
    if @deposit.update(deposit_params)
      redirect_to deposits_path, notice: "貯金を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @deposit.destroy
    redirect_to deposits_path, notice: "貯金を削除しました。"
  end

  private
  def deposit_params
    params.require(:deposit).permit(:is_withdrawn, :amount, :date, :memo)
  end

  def set_deposit
    @deposit = Deposit.find(params[:id])
  end
end
