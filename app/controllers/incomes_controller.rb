class IncomesController < ApplicationController

  def index
    @incomes = current_user.incomes.newer.page(params[:page]).per(10)
  end

  def new
    @income = current_user.incomes.build
  end

  def create
    @income = current_user.incomes.build(income_params)
    if @income.save
      redirect_to incomes_path, notice: "#{@income.amount.to_s(:delimited)}円を収入に追加しました。"
    else
      render 'new'
    end
  end

  def edit
    @income = Income.find(params[:id])
  end

  def update
    @income = Income.find(params[:id])
    if @income.update(income_params)
      redirect_to incomes_path, notice: "収入を更新しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @income = Income.find(params[:id])
    @income.destroy
    redirect_to incomes_path, notice: "収入を削除しました。"
  end

  private
  def income_params
    params.require(:income).permit(:amount, :date, :memo)
  end
end
