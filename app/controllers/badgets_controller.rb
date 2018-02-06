class BadgetsController < ApplicationController
  before_action :set_all_categories, only:[:index, :new, :edit]
  before_action :set_badget, only: [:edit, :update]

  def index
  end

  def new
    @badget = current_user.badgets.new
  end

  def create
    @badget = current_user.badgets.new(badget_params)
    if @badget.save
      category = Category.find(@badget.category_id)
      redirect_to badgets_path, notice: "#{category.kind}の予算を#{@badget.amount}円に設定しました"
    else
      set_all_categories
      render 'new'
    end
  end

  def edit
    @badget = Badget.find(params[:id])
  end

  def update
    if @badget.update(badget_params)
      redirect_to badgets_path
    else
      set_all_categories
      render 'edit'
    end
  end

private
  def set_all_categories
    @categories = Category.all
  end

  def badget_params
    params.require(:badget).permit(:category_id, :amount)
  end

  def set_badget
    @badget = Badget.find(params[:id])
  end
end
