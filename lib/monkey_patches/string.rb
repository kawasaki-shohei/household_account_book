class String

  # @param "2019-01"
  # @return Dateクラス 月初日
  def to_beginning_of_month
    return if self !~ /^\d{4}-\d{2}$/
    Date.parse("#{self}-01")
  end

  # @param "2019-01"
  # @return Dateクラス 月末日
  def to_end_of_month
    return if self !~ /^\d{4}-\d{2}$/
    Date.parse("#{self}-01").end_of_month
  end

end