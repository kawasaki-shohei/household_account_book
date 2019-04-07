class CommonCategoriesController < ApplicationController
  def update
    @category = Category.find(params[:id])
    @category.update!(common: true)  #fixme: エラーハンドリング必要
  end

  def destroy
    @category = Category.find(params[:id])
    @category.update!(common: false)  #fixme: エラーハンドリング必要
  end
end
