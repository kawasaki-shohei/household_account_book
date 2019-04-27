class ExpensesController < ApplicationController
  after_action -> {create_notification(@expense)}, only: [:create, :update]

  def index
    @category = Category.find(params[:category_id])
    @period =  params[:period] || Date.current.to_s_as_period
    @expenses = Expense.specified_category_for_one_month(@current_user, @category, @period)
  end

  def new
    @expense = Expense.new
    @categories = Category.ones_categories(@current_user)
  end

  def create
    @expense = @current_user.expenses.build(expense_params)
    if @expense.save
      category = @expense.category
      set_expenses_list_params(category)
      redirect_to expenses_path(session[:expenses_list_params]), notice: "出費を保存しました。#{category.kind}: #{@expense.amount.to_s(:delimited)}円"
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
    if @expense.update(expense_params)
      category = @expense.category
      set_expenses_list_params(category)
      redirect_to expenses_path(session[:expenses_list_params]), notice: "出費を保存しました。#{category.kind}: #{@expense.amount.to_s(:delimited)}円"
    else
      @categories = Category.ones_categories(@current_user)
      render :edit
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    category = @expense.category
    set_expenses_list_params(category)
    @expense.destroy
    create_notification(@expense)
    redirect_to expenses_path(session[:expenses_list_params]), notice: "出費を削除しました"
  end

  private
  def expense_params
    params.require(:expense).permit(:amount, :category_id, :date, :memo, :both_flg, :mypay, :partnerpay).merge(percent: params[:expense][:percent].to_i)
  end

  def set_expenses_list_params(category)
    session[:expenses_list_params] = { category_id: category.id, period: @expense.date.to_s_as_period }
  end

end
