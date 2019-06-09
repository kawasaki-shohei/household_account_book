module PayDecorator
  include CommonDecorator

  def date_period
    date.strftime("%Y/%m")
  end
end
