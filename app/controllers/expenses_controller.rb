class ExpensesController < ApplicationController
  before_action :check_logging_in
  # before_action :set_expenses_categories, only:[:index, :both]

  def index
    @expense = Expense.new
    set_expenses_categories
  end

  def both
    @expense = Expense.new
    @categories = Category.all
    if current_user.email == "shoheimoment@gmail.com"
      @opponent_user = User.find_by(email: "ikky629@gmail.com")
    elsif current_user.email == "ikky629@gmail.com"
      @opponent_user = User.find_by(email: "shoheimoment@gmail.com")
    end
    @current_user_expenses = current_user.expenses.where(both_flg: true).order(date: :desc)
    @opponent_user_expenses = @opponent_user.expenses.where(both_flg: true).order(date: :desc)

  end

  def create
    @expense = Expense.new(expense_params)
    category = Category.find(params[:expense][:category_id])
    if @expense.save
      redirect_to root_path, notice: "出費を保存しました。#{category.kind}: #{@expense.amount}"
    else
      set_expenses_categories
      render 'index'
    end
  end

  def edit
  end

  private
    def expense_params
      params.require(:expense).permit(:amount, :date, :note, :category_id, :user_id, :both_flg)
    end

    def set_expenses_categories
      @categories = Category.all
      @expenses = current_user.expenses.order(date: :desc)
    end
end
