class ExpensesController < ApplicationController
  after_action -> {create_notification(@expense)}, only: [:create, :update]

  def index
    # @cnum = 0
    # @current_user_expenses = current_user.expenses.this_month
    # @partner_expenses = partner.expenses.this_month
    # @incomes = current_user.incomes.where('date >= ? AND date <= ?', Date.today.beginning_of_month, Date.today.end_of_month)
    # @balances = current_user.balances
    @category = Category.find(params[:category_id])
    @period =  params[:period] || Date.current.to_s_as_year_month
    @expenses = Expense.specified_category_for_one_month(@current_user, @category, @period)
  end

  # def both
  #   if params[:back]
  #     @expense = Expense.new(expense_params)
  #   else
  #     @expense = Expense.new
  #   end
  #   @common_categories = common_categories
  # end

  def new
    # if params[:back]
    #   @expense = Expense.new(expense_params)
    # else
    #   @expense = Expense.new
    # end
    # @categories = Category.ones_categories(current_user, partner)
    @expense = Expense.new
    @categories = Category.ones_categories(@current_user)
  end

  # def confirm
  #   @expense = Expense.new(expense_params)
  #   if @expense.invalid? && @expense.mypay != nil
  #     @common_categories = common_categories
  #     render :both
  #   elsif @expense.invalid?
  #     render :new
  #   end
  # end

  def create
    @expense = @current_user.expenses.build(expense_params)
    if @expense.save
      category = @expense.category
      session[:expenses_list_params] = { category_id: category.id, period: @expense.date.to_s_as_year_month }
      redirect_to expenses_path(session[:expenses_list_params]), notice: "出費を保存しました。#{category.kind}: #{@expense.amount.to_s(:delimited)}円"
    else
      @categories = Category.ones_categories(@current_user)
      render :new
    end
  end

  def edit
    @expense = Expense.find(params[:id])
    if @expense.both_flg == false
      set_expenses_categories
    else
      common_categories
    end
  end

  def update
    @expense = Expense.find(params[:id])
    @category = Category.find(params[:expense][:category_id])
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "出費を保存しました。#{@category.kind}: #{@expense.amount}円"
    else
      render 'edit'
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    create_notification(@expense)
    redirect_to expenses_path, notice: "削除しました"
  end

  def each_category
    cnum = params[:cnum].to_i
    @category = Category.find(params[:category_id].to_i)
    @current_user_expenses = ShiftMonth.ones_expenses(current_user, cnum).category(@category.id)
    @partner_expenses = ShiftMonth.ones_expenses(partner, cnum).category(@category.id)
  end

  private
  # def mypay_amount
  #   whole_payment = params[:expense][:amount].to_i
  #   case params[:expense][:percent].to_i
  #   when 1
  #     mypay = (whole_payment / 2).round
  #   when 2
  #     mypay = (whole_payment / 3).round
  #   when 3
  #     mypay = (whole_payment * 2 / 3).round
  #   when 4
  #     mypay = 0
  #   end
  #   return mypay
  # end

  def expense_params
    params.require(:expense).permit(:amount, :category_id, :date, :memo, :both_flg, :mypay, :partnerpay).merge(percent: params[:expense][:percent].to_i)

    # if params[:expense][:both_flg] == "true" && params[:expense][:percent] == "false"
    #   params.require(:expense).permit(:amount, :date, :memo, :category_id, :both_flg, :mypay, :partnerpay).merge(user_id: current_user.id, percent: nil, repeat_expense_id: nil)
    # elsif params[:expense][:both_flg] == "true"
    #   partnerpay = params[:expense][:amount].to_i - mypay_amount
    #   params.require(:expense).permit(:amount, :date, :memo, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay, repeat_expense_id: nil)
    # else
    #   params.require(:expense).permit(:amount, :date, :memo, :category_id, :both_flg, :percent).merge(user_id: current_user.id, repeat_expense_id: nil)
    # end
  end

  def set_expenses_categories
    @categories = current_user.categories.or(partner.categories.where(common: true))
  end
end
