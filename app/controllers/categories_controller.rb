class CategoriesController < ApplicationController
  before_action :check_logging_in
  include UsersHelper

  def new
    @categories = current_user.categories
    @category = Category.new
    who_is_partner
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to new_category_path, notice: "#{@category.kind}を追加しました"
    else
      render 'new'
    end
  end


  private
  def category_params
    params.require(:category).permit(:kind, :common).merge(user_id: current_user.id)
  end
end
