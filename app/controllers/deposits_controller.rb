class DepositsController < ApplicationController

  def index
    @deposits = Deposit.get_couple_deposits(@current_user).page(params[:page])
    @unpaged_deposits = @deposits.except(:limit, :offset)
  end

  def new
    @deposit = @current_user.deposits.build
  end

  def withdraw
    @deposit = @current_user.deposits.build
  end

  def create
    @deposit = @current_user.deposits.build(deposit_params)
    if @deposit.save
      redirect_to deposits_path, notice: t('deposit.create.succeeded')
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
      redirect_to deposits_path, notice: t('deposit.update.succeeded')
    else
      render :edit
    end
  end

  def destroy
    @deposit = Deposit.find(params[:id])
    @deposit.destroy
    redirect_to deposits_path, notice: t('deposit.destroy.suceeded')
  end

  private
  def deposit_params
    params.require(:deposit).permit(:is_withdrawn, :amount, :date, :memo)
  end

end
