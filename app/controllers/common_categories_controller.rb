class CommonCategoriesController < ApplicationController
  def update
    @category = Category.find(params[:id])
    @category.update!(common: true)  #fixme: エラーハンドリング必要
    if partners_one?(@category)
      render 'move_to_own_category'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.update!(common: false)  #fixme: エラーハンドリング必要
    if partners_one?(@category)
      render 'move_to_partner_category'
    end
  end
end
