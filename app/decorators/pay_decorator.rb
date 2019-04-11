module PayDecorator
  include CommonDecorator

  def date_year_month
    date.strftime("%Y/%m")
  end
end
