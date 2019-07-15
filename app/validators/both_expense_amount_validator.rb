class BothExpenseAmountValidator < ActiveModel::Validator
  def validate(record)
    return unless record.is_for_both?
    if record.mypay.nil? || record.partnerpay.nil? || record.mypay + record.partnerpay != record.amount
      record.errors[:base] << "入力した金額の合計が支払い金額と一致しません"
    end
  end
end