class BadgetsController < ApplicationController
  before_action :set_all_categories, only:[:index, :new]
  def index
    @categories = Category.all
  end

  def new
    @badget = current_user.badgets.new
  end

  def edit
  end

private
  def set_all_categories
    @categories = Category.all
  end
end
