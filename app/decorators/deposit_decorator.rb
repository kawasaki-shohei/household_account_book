module DepositDecorator
  def amount_with_plus_or_minus
    if is_withdrawn
      "▲" + amount.to_s(:delimited)
    else
      amount.to_s(:delimited)
    end
  end
end
