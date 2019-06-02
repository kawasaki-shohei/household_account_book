class ExpensesController < ApplicationController
  include AdjustPeriod

  after_action -> {create_notification(@expense)}, only: [:create, :update]

  def index
    @period =  params[:period] || Date.current.to_s_as_period
    session[:analyses_params][:period] = @period
    session[:expenses_list_params][:period] = @period
    @categories = Category.available_categories_with_budgets(@current_user)
    if params[:category]
      @category = @categories.find{ |c| c.id == params[:category].to_i }
      @expenses = Expense.specified_category_for_one_month(@current_user, @category, @period)
      session[:analyses_params][:category] = params[:category]
      render 'index_specified_category'
    else
      @expenses = Expense.all_for_one_month(@current_user, period_params)
      session[:analyses_params].delete('category')
    end
    if @category.present?
      session[:expenses_list_params][:category] = @category.id
    else
      session[:expenses_list_params].delete('category')
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
      set_expenses_list_params
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
    if @expense.update(expense_params)
      category = @expense.category
      set_expenses_list_params
      redirect_to expenses_path(period: @expense.date.to_s_as_period, expense: @expense.id), notice: "出費を保存しました。#{category.name}: #{@expense.amount.to_s(:delimited)}円"
    else
      @categories = Category.ones_categories(@current_user)
      render :edit
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    set_expenses_list_params
    @expense.destroy
    create_notification(@expense)
    redirect_to expenses_path(period: @expense.date.to_s_as_period), notice: "出費を削除しました"
  end

  private
  def expense_params
    params.require(:expense).permit(:amount, :category_id, :date, :memo, :both_flg, :mypay, :partnerpay).merge(percent: params[:expense][:percent].to_i)
  end

  def set_expenses_list_params
    session['analyses_params'] = { period: @expense.date.to_s_as_period, tab: 'expenses' }
  end

end
