class String

  # @param "2019-01"
  # @return Dateクラス 月初日
  def to_beginning_of_month
    return unless self.match?(year_month_regex)
    Date.parse("#{self}-01")
  end

  # @param "2019-01"
  # @return Dateクラス 月末日
  def to_end_of_month
    return unless self.match?(year_month_regex)
    Date.parse("#{self}-01").end_of_month
  end

  # 来月以降の日付かどうかを判断する
  # @param "2019-01"
  # @return Boolean
  def is_after_next_month?
    return unless self.match?(year_month_regex)
    self.to_beginning_of_month > Date.current.beginning_of_month
  end

  def is_valid_year_month?
    self.match?(year_month_regex)
  end

  def is_invalid_year_month?
    !is_valid_year_month?
  end

  private
  def year_month_regex
    /^\d{4}-\d{2}$/
  end

end