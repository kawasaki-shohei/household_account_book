class CategoriesController < ApplicationController
  before_action :check_logging_in
  before_action :set_category, only:[:edit, :update]
  include UsersHelper, CategoriesHelper

  def new
    @category = Category.new
    @categories = current_user.categories.oneself
    partner
    common_categories
    @partner_categories = @partner.categories.oneself
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to new_category_path, notice: "#{@category.kind}を追加しました"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:name] == "common"
      @category.update(common: true)
    end
    redirect_to new_category_path, notice: "#{@category.kind}を共通のカテゴリーに登録しました！"
  end

  private
  def category_params
    params.require(:category).permit(:kind, :common).merge(user_id: current_user.id)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
