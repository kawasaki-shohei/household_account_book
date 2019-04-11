module BalancesHelper
  def total_balance_amount(balances)
    amount = balances.total_amount
    if amount < 0
      amount_as_string = "▲"  + amount.abs.to_s(:delimited)
    else
      amount_as_string = amount.to_s(:delimited)
    end
    content_tag(:span, amount_as_string + ' 円', class: "info-box-number text-red")
  end
end
