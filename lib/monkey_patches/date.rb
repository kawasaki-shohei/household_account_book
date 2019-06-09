class Date
  def to_s_as_period
    strftime("%Y-%m")
  end

  def to_japanese_period
    strftime("%Y年%m月")
  end

  def self.date_condition_of_query(period=self.current.to_s_as_period)
    period.date_condition_of_query
  end
end