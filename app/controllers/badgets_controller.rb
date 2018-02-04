class BadgetsController < ApplicationController
  before_action :all_categories, only:[:index, :new]
  def index
    @categories = Category.all
  end

  def new
    @badget = current_user.badget.new
  end

  def edit
  end

private
  def set all_categories
    @categories = Category.all
  end
end
