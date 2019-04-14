class Date
  def to_s_as_year_month
    strftime("%Y-%m")
  end

  def to_japanese_year_month
    strftime("%Y年%m月")
  end

  def self.date_condition_of_query(year_month=self.current.to_s_as_year_month)
    year_month.date_condition_of_query
  end
end