class ExpensesController < ApplicationController
  before_action :check_logging_in
  include ExpensesHelper

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
    who_is_partner(current_user)

    end_of_month = Date.today.end_of_month
    beginning_of_month = Date.today.beginning_of_month

    @current_user_expenses = current_user.expenses.where!('date >= ? AND date <= ?', beginning_of_month, end_of_month)
    @current_user_expenses.where!(both_flg: true).order!(date: :desc)

    @partner_expenses = @partner.expenses.where!('date >= ? AND date <= ?', beginning_of_month, end_of_month)
    @partner_expenses.where!(both_flg: true).order!(date: :desc)

    @sum = @current_user_expenses.sum(:mypay) + @partner_expenses.sum(:partnerpay)

  end

  def create
    category = Category.find(params[:expense][:category_id])
    @expense = Expense.new(expense_params)
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
    def mypay_amount
      whole_payment = params[:expense][:amount].to_i
      case params[:expense][:percent].to_i
      when 1
        mypay = (whole_payment / 2).round
      when 2
        mypay = (whole_payment / 3).round
      when 3
        mypay = (whole_payment * 2 / 3).round
      when 4
        mypay = 0
      end
      return mypay
    end

    def expense_params
      if params[:expense][:both_flg] == false
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge!(user_id: current_user.id)
      else
        partnerpay = params[:expense][:amount].to_i - mypay_amount
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge!(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay )
      end
    end

    def set_expenses_categories
      @categories = Category.all
      # @expenses = current_user.expenses.order(date: :desc)
    end
end
