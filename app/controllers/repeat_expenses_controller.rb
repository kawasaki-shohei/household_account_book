class RepeatExpensesController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner
  # before_action :back_or_new, only:[:new, :both, :edit]
  before_action :set_expense, only:[:edit, :update, :destroy]
  before_action :set_category, only:[:update]
  include CategoriesHelper

  def index
    @cnum = 0
    @current_user_expenses = Expense.ones_expenses(current_user)
    @current_user_expenses_of_both = Expense.ones_expenses_of_both(current_user)
    @partner_expenses_of_both = Expense.ones_expenses_of_both(partner)
    @sum = @current_user_expenses.sum(:amount)
    @both_sum = Expense.must_pay_this_month(current_user, partner)
    @category_sums = Expense.category_sums(@current_user_expenses, @current_user_expenses_of_both, @partner_expenses_of_both)
    @category_badgets = current_user.badgets
  end

  def both
    common_categories
  end

  def new
    @expense = RepeatExpense.new
    @categories = Category.ones_categories(current_user, partner)
  end

  def create
    binding.pry
    @repeat_expense = RepeatExpense.new(repeat_expense_params)
    if @repeat_expense.save
      start_date = Date.parse(params[:repeat_expense][:s_date])
    end_date =  Date.parse(params[:repeat_expense][:e_date]
    day = params[:repeat_expense][:day].to_i
      redirect_to expenses_path, notice: "出費を保存しました。#{@category.kind}: #{@expense.amount}"
    else
      set_expenses_categories
      render 'index'
    end
  end

  def edit
    if @expense.both_flg == false
      set_expenses_categories
    else
      common_categories
    end
  end

  def update
    if @expense.update(repeat_expense_params)
      redirect_to expenses_path, notice: "出費を保存しました。#{@category.kind}: #{@expense.amount}"
    else
      render 'edit'
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "削除しました"
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

    def repeat_expense_params
      if params[:repeat_expense][:both_flg] == "true"
        partnerpay = params[:repeat_expense][:amount].to_i - mypay_amount
        params.require(:repeat_expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay )
      else
        params.require(:repeat_expense).permit(:amount, :s_date, :e_date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id)
      end
    end

    def set_expenses_categories
      @categories = Category.where(user_id: current_user.id).or(Category.where(user_id: partner.id, common: true))
    end

    def back_or_new
      if params[:back]
        @expense = RepeatExpense.new(repeat_expense_params)
      else
        @expense = RepeatExpense.new
      end
    end

    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_category
      @category = Category.find(params[:repeat_expense][:category_id])
    end
end
