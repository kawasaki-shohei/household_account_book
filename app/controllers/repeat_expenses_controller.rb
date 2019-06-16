class RepeatExpensesController < ApplicationController
  after_action -> {create_notification(@repeat_expense)}, only: [:create]
  include CategoriesHelper

  def index
    @repeat_expenses = RepeatExpense.includes(:user, :category).where(user: [@current_user, @partner]).order(created_at: :desc)
  end

  def new
    @repeat_expense = RepeatExpense.new
    @categories = Category.ones_categories(@current_user)
  end

  def create
    @repeat_expense = @current_user.repeat_expenses.build(repeat_expense_params)
    errors = []
    ActiveRecord::Base.transaction do
      if @repeat_expense.save
        begin
          Expense.creat_repeat_expenses!(@repeat_expense)
        rescue
          flash.now[:error] = ["繰り返し出費に紐づいている各出費の登録に失敗しました。"]
          raise ActiveRecord::Rollback
        end
      else
        flash.now[:error] = @repeat_expense.errors.full_messages
        raise ActiveRecord::Rollback
      end
    end
    if flash[:error].blank?
      redirect_to repeat_expenses_path, notice: "繰り返し出費を保存しました。"
    else
      @categories = Category.ones_categories(current_user)
      render 'new'
    end

  end

  def edit
    @repeat_expense = RepeatExpense.find(params[:id])
    @categories = Category.ones_categories(@current_user)
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
  def repeat_expense_params
    params.require(:repeat_expense).permit(:amount, :category_id, :s_date, :e_date, :r_date, :memo, :both_flg, :mypay, :partnerpay).merge(percent: params[:repeat_expense][:percent].to_i)
  end
end
