class BadgetsController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    
  end

  def edit
  end
end
