class String

  # @param "2019-01"
  # @return Date 月初日
  def to_beginning_of_month
    return unless self.match?(year_month_regex)
    Date.parse("#{self}-01")
  end

  # @param "2019-01"
  # @return Date 月末日
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

  # 前月を返す "2019-01"
  # @return String
  def to_last_year_month
    return unless self.match?(year_month_regex)
    to_beginning_of_month.last_month.to_s_as_year_month
  end

  # 来月を返す "2019-01"
  # @return String
  def to_next_year_month
    return unless self.match?(year_month_regex)
    to_beginning_of_month.next_month.to_s_as_year_month
  end

  # "2019-01" → "2019年01月"
  # @return String
  def to_japanese_year_month
    return unless self.match?(year_month_regex)
    "#{year_string}年#{month_string}月"
  end

  # @return String "2019"
  def year_string
    return unless self.match?(year_month_regex)
    extract_year_month[0]
  end

  # @return Integer 2019
  def year_number
    year_string.to_i
  end

  # @return String "02"
  def month_string
    return unless self.match?(year_month_regex)
    extract_year_month[1]
  end

  # @return Integer 4
  def month_number
    month_string.to_i
  end

  # @return Boolean
  def is_valid_year_month?
    self.match?(year_month_regex)
  end

  # @return Boolean
  def is_invalid_year_month?
    !is_valid_year_month?
  end

  # @return Array
  def date_condition_of_query
    return unless self.match?(year_month_regex)
    ['date >= ? AND date <= ?', to_beginning_of_month, to_end_of_month]
  end

  private
  def year_month_regex
    /^\d{4}-\d{2}$/
  end

  def extract_year_month
    /(?<year>\d{4})-(?<month>\d{2})/ =~ self
    [year, month]
  end

end