class CategoriesController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner
  before_action :set_category, only:[:edit, :update]
  before_action :set_categories, only:[:index, :common]
  include UsersHelper, CategoriesHelper

  def index
  end

  def common
    @partner_categories = partner.categories.oneself
  end

  def new
    @category = Category.new
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
      redirect_to common_categories_path, notice: "#{@category.kind}を共通のカテゴリに登録しました！"
    elsif @category.update(kind: params[:category][:kind])
      redirect_to categories_path, notice: "カテゴリ名を変更しました"
    end
  end


  private
  def category_params
    params.require(:category).permit(:kind, :common).merge(user_id: current_user.id)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def set_categories
    @my_categories = current_user.categories.oneself
    common_categories
  end
end
