class BudgetsController < ApplicationController
  before_action :set_all_categories, only:[:new, :edit]
  before_action :set_budget, only: [:edit, :update]

  def index
    @categories = current_user.categories.or(partner.categories.common_t).includes(:budgets).order(:id)
    @budgets = current_user.budgets.order(category_id: :asc)
  end

  def new
    @budget = Budget.new
  end

  def create
    @budget = current_user.budgets.new(budget_params)
    check = Budget.find_by(user_id: current_user.id, category_id: params[:category_id])
    if check.present?
      @budget.errors[:base] << "同じカテゴリに２つの予算を設定できません。予算を編集してください。"
      set_all_categories
      render 'new'
    end

    if @budget.save
      find_budget_category
      redirect_to budgets_path, notice: "#{@category.kind}の予算を#{@budget.amount}円に設定しました"
    else
      set_all_categories
      render 'new'
    end
  end

  def edit
  end

  def update
    if @budget.update(budget_params)
      find_budget_category
      redirect_to budgets_path, notice: "#{@category.kind}の予算を#{@budget.amount}円に設定しました"
    else
      set_all_categories
      render 'edit'
    end
  end

private
  def set_all_categories
    @categories = current_user.categories.or(partner.categories.common_t)
  end

  def budget_params
    params.require(:budget).permit(:category_id, :amount)
  end

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def find_budget_category
    @category = Category.find(@budget.category_id)
  end
end
