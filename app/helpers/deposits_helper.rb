module DepositsHelper
  def total_deposits_amount(deposits)
    deposits.sum(&:amount)
  end
end