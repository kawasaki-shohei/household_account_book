module BalanceDecorator
  include CommonDecorator

  def amount_with_plus_or_minus
    amount < 0 ? red_amount : amount.to_s(:delimited)
  end

end
