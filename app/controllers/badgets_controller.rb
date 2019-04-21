class BadgetsController < ApplicationController

  def index
    @categories = Category.get_user_categories_with_badgets(current_user)
  end

  def new
    @badget = Badget.new
    @categories = Category.get_user_categories_with_badgets(current_user)
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
    @badget = Badget.find(params[:id])
    @category= @badget.category
  end

  def update
    @badget = Badget.find(params[:id])
    if @badget.update(badget_params)
      find_badget_category
      redirect_to badgets_path, notice: "#{@category.kind}の予算を#{@badget.amount}円に設定しました"
    else
      set_all_categories
      render 'edit'
    end
  end

  def destroy
    @badget = Badget.find(params[:id])
    @category = @badget.category
    @badget.destroy
    redirect_to badgets_path, notice: "#{@category.kind}の予算を削除しました。"
  end

  private
  def badget_params
    params.require(:badget).permit(:category_id, :amount)
  end

  def find_badget_category
    @category = Category.find(@badget.category_id)
  end
end
