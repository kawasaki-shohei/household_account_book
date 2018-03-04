class ExpensesController < ApplicationController
  before_action :check_logging_in
  before_action :set_expenses_categories, only:[:new, :edit]
  before_action :back_or_new, only:[:new, :both, :edit]
  before_action :set_expense, only:[:edit, :update, :destroy]
  before_action :set_category, only:[:update, :create]
  before_action :partner, only:[:index, :both, :new]
  include UsersHelper, CategoriesHelper

  def index
    # 自分一人の出費
    @current_user_expenses = current_user.expenses.this_month.both_f.newer
    @sum = @current_user_expenses.sum(:amount)

    # 二人の出費の内、自分が払うもの、上記との違いはboth_flgのみ
    @current_user_expenses_of_both = current_user.expenses.this_month.both_t.newer

    # 相手が記入した二人の出費の内、自分が払うもの
    @partner_expenses_of_both = @partner.expenses.this_month.both_t.newer

    # 二人の出費の内、自分が払う金額の合計
    @both_sum = @current_user_expenses_of_both.sum(:mypay) + @partner_expenses_of_both.sum(:partnerpay)

    @category_badgets = current_user.badgets
  end

  def both
    common_categories
  end

  def new
  end

  def confirm
    @expense = Expense.new(expense_params)
    render :new if @expense.invalid?
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to root_path, notice: "出費を保存しました。#{@category.kind}: #{@expense.amount}"
    else
      set_expenses_categories
      render 'index'
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
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

    def expense_params
      if params[:expense][:both_flg] == "true"
        partnerpay = params[:expense][:amount].to_i - mypay_amount
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay )
      else
        params.require(:expense).permit(:amount, :date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id)
      end
    end

    def set_expenses_categories
      @categories = Category.where(user_id: current_user.id).or(Category.where(user_id: partner.id, common: true))
    end

    def back_or_new
      if params[:back]
        @expense = Expense.new(expense_params)
      else
        @expense = Expense.new
      end
    end

    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_category
      @category = Category.find(params[:expense][:category_id])
    end
end
