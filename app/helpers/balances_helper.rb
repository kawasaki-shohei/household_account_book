module BalancesHelper
  def total_balance_amount(balances)
    amount = balances.total_amount
    if amount < 0
      amount_as_string = "-"  + amount.abs.to_s(:delimited)
      text_color = 'text-redpepper'
    else
      amount_as_string = amount.to_s(:delimited)
      text_color = ''
    end
    content_tag(:div, class: "info-box-number #{text_color}") do
      concat tag.i(class: "fa fa-cny")
      concat tag.span(amount_as_string, class:"space-left")
    end
  end
end
