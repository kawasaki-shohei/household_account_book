class RepeatExpensesController < ApplicationController
  after_action -> {create_notification(@repeat_expense)}, only: [:create]
  include CategoriesHelper

  def index
    @current_user_expenses = current_user.repeat_expenses
    @partner_expenses = partner.repeat_expenses
  end

  def both
    if params[:back]
      @expense = RepeatExpense.new(repeat_expense_params)
    else
      @expense = RepeatExpense.new
    end
    @common_categories = common_categories
  end

  def new
    if params[:back]
      @expense = RepeatExpense.new(repeat_expense_params)
    else
      @expense = RepeatExpense.new
    end
    @categories = Category.ones_categories(current_user)
  end

  def confirm
    @expense = RepeatExpense.new(repeat_expense_params)
    render :new if @expense.invalid?
  end

  def create
    @repeat_expense = RepeatExpense.new(repeat_expense_params)
    if @repeat_expense.save
      Expense.creat_repeat_expenses(@repeat_expense, expense_params)
      redirect_to repeat_expenses_path, notice: "繰り返し出費を保存しました。"
    else
      @categories = Category.ones_categories(current_user)
      render 'index'
    end
  end

  def edit
    @expense = RepeatExpense.find(params[:id])
    if @expense.both_flg == false
      @categories = Category.ones_categories(current_user)
    else
      @common_categories = common_categories
    end
  end

  def update
    @repeat_expense = RepeatExpense.find(params[:id])
    old = @repeat_expense
    if @repeat_expense.update(repeat_expense_params)
      Expense.update_repeat_expense(old, @repeat_expense, expense_params)
      redirect_to repeat_expenses_path, notice: "繰り返し出費を編集しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @repeat_expense = RepeatExpense.find(params[:id])
    Expense.destroy_repeat_expenses(current_user, @repeat_expense.id)
    create_notification(@repeat_expense)
    @repeat_expense.destroy
    redirect_to repeat_expenses_path, notice: "削除しました"
  end

  private
  def mypay_amount
    whole_payment = params[:repeat_expense][:amount].to_i
    case params[:repeat_expense][:percent].to_i
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

  # FIXME expense_paramsとほぼ同じ。.buildを使ってmergeを消す。
  def repeat_expense_params
    if params[:repeat_expense][:both_flg] == "true"
      partnerpay = params[:repeat_expense][:amount].to_i - mypay_amount
      params.require(:repeat_expense).permit(:amount, :s_date, :e_date, :r_date, :memo, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay )
    else
      params.require(:repeat_expense).permit(:amount, :s_date, :e_date, :r_date, :memo, :category_id, :both_flg, :percent).merge(user_id: current_user.id)
    end
  end

  def expense_params
    if params[:repeat_expense][:both_flg] == "true"
      partnerpay = params[:repeat_expense][:amount].to_i - mypay_amount
      params.require(:repeat_expense).permit(:amount, :memo, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay )
    else
      params.require(:repeat_expense).permit(:amount, :memo, :category_id, :both_flg, :percent).merge(user_id: current_user.id)
    end
  end

  def set_expenses_categories
    @categories = Category.where(user_id: current_user.id).or(Category.where(user_id: partner.id, common: true))
  end
end
