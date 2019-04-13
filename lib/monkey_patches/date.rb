class Date
  def to_s_as_year_month
    strftime("%Y-%m")
  end

  def to_japanese_year_month
    strftime("%Y年%m月")
  end
end