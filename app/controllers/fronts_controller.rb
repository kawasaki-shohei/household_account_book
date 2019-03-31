class FrontsController < ApplicationController
  def index
    @pays = Pay.all_payments(current_user, partner)
    @my_last_payment = 1000
    @my_payment = -1000
    @balance = 0
  end

  def new
    @pay = Pay.new
  end
end
