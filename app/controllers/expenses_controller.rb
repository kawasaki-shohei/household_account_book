class ExpensesController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner
  before_action :set_expense, only:[:edit, :update, :destroy]
  before_action :set_category, only:[:update, :create]
  include CategoriesHelper

  def index
    @cnum = 0
    @current_user_expenses = Expense.ones_expenses(current_user)
    @current_user_expenses_of_both = Expense.ones_expenses_of_both(current_user)
    @partner_expenses_of_both = Expense.ones_expenses_of_both(partner)
    @sum = @current_user_expenses.sum(:amount)
    @both_sum = Expense.must_pay_this_month(current_user, partner)
    binding.pry
    @category_sums = Expense.category_sums(@current_user_expenses, @current_user_expenses_of_both, @partner_expenses_of_both)
    @category_badgets = current_user.badgets
  end

  def both
    if params[:back]
      @expense = Expense.new(expense_params)
    else
      @expense = Expense.new
    end
    @common_categories = common_categories
  end

  def new
    if params[:back]
      @expense = Expense.new(expense_params)
    else
      @expense = Expense.new
    end
    @categories = Category.ones_categories(current_user, partner)
  end


  def confirm
    @expense = Expense.new(expense_params)
    if @expense.invalid? && @expense.mypay != nil
      @common_categories = common_categories
      render :both
    elsif @expense.invalid?
      render :new
    end
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: "出費を保存しました。#{@category.kind}: #{@expense.amount}円"
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
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "出費を保存しました。#{@category.kind}: #{@expense.amount}円"
    else
      render 'edit'
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "削除しました"
  end

  def each_category
    cnum = params[:cnum].to_i
    @category = Category.find(params[:category_id].to_i)
    @current_user_expenses = Expense.category_expense(current_user, partner, cnum, @category)[0]
    @current_user_expenses_of_both = Expense.category_expense(current_user, partner, cnum, @category)[1]
    @partner_expenses_of_both = Expense.category_expense(current_user, partner, cnum, @category)[2]
    @sum = @current_user_expenses.unscope(:order).where(category_id: @category.id).sum(:amount)
    @both_sum = Expense.category_expense(current_user, partner, cnum, @category)[3]
    respond_to do |format|
      format.js
    end
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
      if params[:expense][:both_flg] == "true" && params[:expense][:percent] == "false"
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :mypay, :partnerpay).merge(user_id: current_user.id, percent: nil, repeat_expense_id: nil)
      elsif params[:expense][:both_flg] == "true"
        partnerpay = params[:expense][:amount].to_i - mypay_amount
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay, repeat_expense_id: nil)
      else
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id, repeat_expense_id: nil)
      end
    end

    def set_expenses_categories
      @categories = current_user.categories.or(partner.categories.where(common: true))
      # @categories = Category.where(user_id: current_user.id).or(Category.where(user_id: partner.id, common: true))
    end

    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_category
      @category = Category.find(params[:expense][:category_id])
    end
end
