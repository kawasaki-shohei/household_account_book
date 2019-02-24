module PaysHelper
  def payment_amount_as_string(amount)
    if amount < 0
      amount.abs.to_s(:delimited) + "円受け取る"
    elsif amount > 0
      amount.abs.to_s(:delimited) + "円渡す"
    else amount == 0
      "0 円"
    end
  end
end
