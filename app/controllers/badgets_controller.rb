class BadgetsController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner
  before_action :set_all_categories, only:[:index, :new, :edit]
  before_action :set_badget, only: [:edit, :update]

  def index
  end

  def new
    @badget = Badget.new
  end

  def create
    @badget = current_user.badgets.new(badget_params)
    check = Badget.find_by(user_id: current_user.id, category_id: params[:category_id])
    if check.present?
      @badget.errors[:base] << "同じカテゴリに２つの予算を設定できません。予算を編集してください。"
      set_all_categories
      render 'new'
    end

    if @badget.save
      find_badget_category
      redirect_to badgets_path, notice: "#{@category.kind}の予算を#{@badget.amount}円に設定しました"
    else
      set_all_categories
      render 'new'
    end
  end

  def edit
  end

  def update
    if @badget.update(badget_params)
      find_badget_category
      redirect_to badgets_path, notice: "#{@category.kind}の予算を#{@badget.amount}円に設定しました"
    else
      set_all_categories
      render 'edit'
    end
  end

private
  def set_all_categories
    @categories = current_user.categories
  end

  def badget_params
    params.require(:badget).permit(:category_id, :amount)
  end

  def set_badget
    @badget = Badget.find(params[:id])
  end

  def find_badget_category
    @category = Category.find(@badget.category_id)
  end
end
