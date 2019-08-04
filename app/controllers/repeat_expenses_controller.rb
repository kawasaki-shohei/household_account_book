class RepeatExpensesController < ApplicationController
  after_action -> {create_notification(@repeat_expense)}, only: [:create]
  include CategoriesHelper

  def index
    @repeat_expenses = LatestRepeatExpense.includes(:user, :category).where(user: [@current_user, @partner]).order(item_id: :desc)
  end

  def new
    @repeat_expense = RepeatExpense.new
    @categories = Category.ones_categories(@current_user)
  end

  def create
    @repeat_expense = @current_user.repeat_expenses.build(repeat_expense_params)
    @repeat_expense.set_new_item_id
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
    if new_repeat_expense.updated_only_future? && @repeat_expense.start_date != new_repeat_expense.start_date && @repeat_expense.start_date < Date.current
      flash.now[:error] = ["未来の出費のみ変更する場合、今日より過去に設定されている開始日は変更できません。"]
      @repeat_expense.assign_attributes(repeat_expense_params)
      @categories = Category.ones_categories(@current_user)
      render 'edit' and return
    end

    if new_repeat_expense.updated_only_future?
      destroy_target_expenses = @repeat_expense.expenses.where('date >= ?', Date.current)
    elsif new_repeat_expense.updated_all?
      destroy_target_expenses = @repeat_expense.expenses
    end
    ActiveRecord::Base.transaction do
      if new_repeat_expense.save
        destroy_target_expenses.destroy_all
        begin
          Expense.creat_repeat_expenses!(new_repeat_expense)
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
    target_repeat_expenses = @current_user.repeat_expenses.where(item_id: @repeat_expense.item_id).order(item_sub_id: :desc)
    target_expenses = Expense.where(repeat_expense_id: target_repeat_expenses.map(&:id))
    ActiveRecord::Base.transaction do
      begin
        if params[:updated_period] == "updated_all"
          target_expenses.each(&:destroy)
          target_repeat_expenses.each(&:destroy)
        elsif params[:updated_period] == "updated_only_future"
          target_expenses.each do |expense|
            if expense.date >= Date.current
              expense.destroy
            end
          end
          target_repeat_expenses.each(&:destroy)
        end
      rescue
        flash[:error] = ["繰り返し出費の削除に失敗しました。"]
        raise ActiveRecord::Rollback
      end
    end

    if flash[:error].blank?
      redirect_to repeat_expenses_path, notice: "繰り返し出費と関連する出費を削除しました。"
    else
      redirect_to edit_repeat_expense_path(@repeat_expense)
    end
  end

  private
  def repeat_expense_params
    permitted_params = params.require(:repeat_expense).permit(:amount, :category_id, :start_date, :end_date, :repeat_day, :memo, :is_for_both, :mypay, :partnerpay).merge(percent: params[:repeat_expense][:percent].to_i)
    if params[:updated_only_future].present?
      permitted_params.merge!(updated_period: "updated_only_future")
    elsif params[:updated_all].present?
      permitted_params.merge!(updated_period: "updated_all")
    end
    permitted_params
  end
end
