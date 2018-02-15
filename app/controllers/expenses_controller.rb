class ExpensesController < ApplicationController
  before_action :check_logging_in
  before_action :set_what_month, only: [:index, :both]
  # before_action :set_expenses_categories, only:[:index, :both]

  def index
    @expense = Expense.new
    end_of_month = Date.today.end_of_month
    beginning_of_month = Date.today.beginning_of_month
    @expenses = Expense.where('date >= ? AND date <= ?', beginning_of_month, end_of_month)
    @expenses.where!(both_flg: false)
    @expenses.order!(date: :desc)
    @sum = @expenses.sum(:amount)
    set_expenses_categories
  end

  def both
    @expense = Expense.new
    @categories = Category.all
    if current_user.email == "shoheimoment@gmail.com"
      @partner = User.find_by(email: "ikky629@gmail.com")
    elsif current_user.email == "ikky629@gmail.com"
      @partner = User.find_by(email: "shoheimoment@gmail.com")
    end
    end_of_month = Date.today.end_of_month
    beginning_of_month = Date.today.beginning_of_month
    @current_user_expenses = current_user.expenses.where!('date >= ? AND date <= ?', beginning_of_month, end_of_month)
    @current_user_expenses.where!(both_flg: true).order!(date: :desc)

    @partner_expenses = @partner.expenses.where!('date >= ? AND date <= ?', beginning_of_month, end_of_month)
    @partner_expenses.where!(both_flg: true).order!(date: :desc)

    @sum = @current_user_expenses.sum(:amount) + @partner_expenses.sum(:amount)
    # 自分 → 払った金額 * percent
    #
    # 相手 → 払った金額 - (払った金額 * percent)

  end

  def create
    category = Category.find(params[:expense][:category_id])
    @expense = Expense.new(expense_params)
    if params[:expense][:both_flg] == true
      @expense.mypay = (params[:expense][:amount].to_i * params[:expense][:percent].to_f).round
      @expense.save
      @expense.partnerpay = params[:expense][:amount].to_i - @expense.mypay
    end
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
      if params[:expense][:both_flg] == false
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge!(user_id: current_user.id)
      else
        mypay = (params[:expense][:amount].to_i * params[:expense][:percent].to_f).round
        partnerpay = params[:expense][:amount].to_i - mypay
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge!(user_id: current_user.id, mypay: mypay, partnerpay: partnerpay )
      end
    end

    def set_expenses_categories
      @categories = Category.all
      # @expenses = current_user.expenses.order(date: :desc)
    end

    def set_what_month
      end_of_month = Date.today.end_of_month
      beginning_of_month = Date.today.beginning_of_month
    end
end
