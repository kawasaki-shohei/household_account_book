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
    @repeat_expense.set_new_item_id
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
      @categories = Category.ones_categories(@current_user)
      render 'new'
    end

  end

  def edit
    @repeat_expense = RepeatExpense.find(params[:id])
    @categories = Category.ones_categories(@current_user)
  end

  def update
    @repeat_expense = RepeatExpense.find(params[:id])
    new_repeat_expense = @current_user.repeat_expenses.build(repeat_expense_params)
    new_repeat_expense.set_next_item_sub_id(@repeat_expense)
    if params[:future_expenses].present? && @repeat_expense.s_date != new_repeat_expense.s_date && @repeat_expense.s_date < Date.current
      flash.now[:error] = ["未来の出費のみ変更する場合、今日より過去に設定されている開始日は変更できません。"]
      @repeat_expense.assign_attributes(repeat_expense_params)
      @categories = Category.ones_categories(@current_user)
      render 'edit' and return
    end

    if params[:future_expenses].present?
      expenses = @repeat_expense.expenses.where('date >= ?', Date.current)
    else
      expenses = @repeat_expense.expenses
    end
    ActiveRecord::Base.transaction do
      if new_repeat_expense.save
        expenses.destroy_all
        begin
          Expense.creat_repeat_expenses!(new_repeat_expense, is_only_future: params[:future_expenses].present?)
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
      redirect_to repeat_expenses_path, notice: "繰り返し出費を更新しました。"
    else
      @repeat_expense.assign_attributes(repeat_expense_params)
      @categories = Category.ones_categories(@current_user)
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
