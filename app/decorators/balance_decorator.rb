module BalanceDecorator
  include CommonDecorator
  # "2019-01" → "2019年01月"
  def japanese_month
    /(?<year>\d{4})-(?<_month>\d{2})/ =~ month
    "#{year}年#{_month}月"
  end

  def amount_with_plus_or_minus
    amount < 0 ? red_amount : amount.to_s(:delimited)
  end

end
