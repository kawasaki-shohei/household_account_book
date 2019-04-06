module DepositDecorator
  include CommonDecorator
  def amount_with_plus_or_minus
    if is_withdrawn
      red_amount
    else
      amount.to_s(:delimited)
    end
  end
end
