class CategoriesController < ApplicationController
  after_action -> {create_notification(@category)}, only: [:create, :update]
  include CategoriesHelper

  def index
    @categories = Category.includes(:user).where(user: [@current_user, @partner]).order(:id)
    # @my_categories = current_user.categories.oneself
    # @common_categories = Category.where('user_id = ? OR user_id = ?', current_user.id, partner.id).where(common: true)
  end

  def new
    @category = Category.new
  end

  def create
    @category = @current_user.categories.build(category_params)
    @category.save!  #fixme: エラーハンドリング必要
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    @category.update(category_params)   #fixme: エラーハンドリング必要
  end

  def cancel
    if params[:id]
      @category = Category.find(params[:id])
    else
      render 'remove_new_category_form'
    end
  end


  private
  def category_params
    params.require(:category).permit(:kind, :common)
  end
end
