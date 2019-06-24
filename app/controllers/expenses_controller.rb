class ExpensesController < ApplicationController
  include PeriodAdjuster

  after_action -> {create_notification(@expense)}, only: [:create, :update]

  def index
    @period =  params[:period] || Date.current.to_s_as_period
    @categories = Category.available_categories_with_budgets(@current_user)
    if params[:category]
      @category = @categories.find{ |c| c.id == params[:category].to_i }
      @expenses = Expense.specified_category_for_one_month(@current_user, @category, @period)
      session[:expenses_list_category] = @category.id
      render 'index_specified_category'
    else
      @expenses = Expense.all_for_one_month(@current_user, period_params)
      session.delete(:expenses_list_category)
    end
  end

  def new
    @expense = Expense.new
    @categories = Category.ones_categories(@current_user)
  end

  def create
    @expense = @current_user.expenses.build(expense_params)
    if @expense.save
      category = @expense.category
      redirect_to expenses_path(period: @expense.date.to_s_as_period, expense: @expense.id), notice: "出費を保存しました。#{category.name}: #{@expense.amount.to_s(:delimited)}円"
    else
      @categories = Category.ones_categories(@current_user)
      render :new
    end
  end

  def edit
    @expense = Expense.find(params[:id])
    @categories = Category.ones_categories(@current_user)
  end

  def update
    @expense = Expense.find(params[:id])
    @expense.assign_attributes(expense_params.merge(repeat_expense_id: nil))
    if @expense.update(expense_params)
      category = @expense.category
      redirect_to expenses_path(period: @expense.date.to_s_as_period, expense: @expense.id), notice: "出費を保存しました。#{category.name}: #{@expense.amount.to_s(:delimited)}円"
    else
      @categories = Category.ones_categories(@current_user)
      render :edit
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    create_notification(@expense)
    redirect_to expenses_path(period: @expense.date.to_s_as_period), notice: "出費を削除しました"
  end

  private
  def expense_params
    params.require(:expense).permit(:amount, :category_id, :date, :memo, :both_flg, :mypay, :partnerpay).merge(percent: params[:expense][:percent].to_i)
  end

end
