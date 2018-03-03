class CategoriesController < ApplicationController
  before_action :check_logging_in

  def new
    @categories = Category.all
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


  private
  def category_params
    params.require(:category).permit(:kind).merge(user_id: current_user.id)
  end
end
