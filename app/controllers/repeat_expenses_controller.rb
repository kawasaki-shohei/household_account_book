class RepeatExpensesController < ApplicationController
  def new
    @expense = Expense.new
  end

  def edit
  end

  private
  def repeat_expense_params
    params.require(:expense).permit(:amount, :)
end
