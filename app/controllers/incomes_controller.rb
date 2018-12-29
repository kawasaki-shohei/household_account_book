class IncomesController < ApplicationController
  def index
    @incomes = current_user.incomes.order(date: :desc)
  end

  def new
    @income = current_user.incomes.build
  end

  def create
    @income = current_user.incomes.build(income_params)
    if @income.save
      redirect_to incomes_path, notice: "#{@income.amount.to_s(:delimited)}円を収入に追加しました。"
    else
      render :new
    end
  end

  private
  def income_params
    params.require(:income).permit(:amount, :date, :memo)
  end
end
