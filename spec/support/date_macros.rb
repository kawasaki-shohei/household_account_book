module DateMacros

  def random_this_month_date
    from = Date.current.beginning_of_month
    to = Date.current.end_of_month
    random_date(from, to)
  end

  def random_past_month_date
    from = Date.current.last_year.beginning_of_month
    to = Date.current.months_ago(1).end_of_month
    random_date(from, to)
  end

  # [String] period
  def random_specific_month_date(period:)
    from = period.to_beginning_of_month
    to = period.to_end_of_month
    random_date(from, to)
  end

  private
  def random_date(from, to)
    Faker::Date.between(from: from, to: to)
  end

end