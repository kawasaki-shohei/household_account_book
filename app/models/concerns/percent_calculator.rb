module PercentCalculator
  def calculate_amount
    return unless is_for_both?
    if mypay.nil? || partnerpay.nil? || mypay + partnerpay != amount
      errors[:base] << "入力した金額の合計が支払い金額と一致しません"
    end
  end

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