module PercentCalculator
  def set_mypay_and_partnerpay
    return if !is_for_both?
    case percent
    when "pay_all"
      self.mypay = amount
      self.partnerpay = 0
    when "pay_half"
      self.mypay = (amount / 2).round
      self.partnerpay = (amount - mypay)
    when "pay_one_third"
      self.mypay = (amount / 3).round
      self.partnerpay = (amount - mypay)
    when "pay_two_thirds"
      self.mypay = (amount * 2 / 3).round
      self.partnerpay = (amount - mypay)
    when "pay_nothing"
      self.mypay = 0
      self.partnerpay = amount
    end
  end
end