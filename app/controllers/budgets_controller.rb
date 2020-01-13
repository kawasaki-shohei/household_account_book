class BudgetsController < ApplicationController

  def index
    @categories = Category.get_user_categories_with_budgets(current_user)
  end

  def new
    @budget = Budget.new
    @categories = Category.get_user_categories_with_budgets(current_user)
  end

  def create
    @budget = current_user.budgets.new(budget_params)
    check = Budget.find_by(user_id: current_user.id, category_id: params[:category_id])
    if check.present?
      @budget.errors[:base] << "同じカテゴリに２つの予算を設定できません。予算を編集してください。"
      @categories = Category.get_user_categories_with_budgets(current_user)
      render 'new'
    end

    if @budget.save
      @category = Category.find(@budget.category_id)
      redirect_to budgets_path, notice: "#{@category.name}の予算を#{@budget.amount}円に設定しました"
    else
      @categories = Category.get_user_categories_with_budgets(current_user)
      render 'new'
    end
  end

  def edit
    @budget = Budget.find(params[:id])
    @category= @budget.category
  end

  def update
    @budget = Budget.find(params[:id])
    if @budget.update(budget_params)
      @category = Category.find(@budget.category_id)
      redirect_to budgets_path, notice: "#{@category.name}の予算を#{@budget.amount}円に設定しました"
    else
      @category= @budget.category
      render 'edit'
    end
  end

  def destroy
    @budget = Budget.find(params[:id])
    @category = @budget.category
    @budget.destroy
    redirect_to budgets_path, notice: "#{@category.name}の予算を削除しました。"
  end

  private
  def budget_params
    params.require(:budget).permit(:category_id, :amount)
  end
end
