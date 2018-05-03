class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true

  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.ones_all_payment(user)
    user.pays.sum(:pamount)
  end

  def self.ones_gross(user)
    user.expenses.until_last_month.both_t.sum(:amount) + ones_all_payment(user)
  end

  def self.all_payments(current_user, partner)
    current_user.pays.or(partner.pays).newer
  end

  def self.must_pay(current_user, partner)
    current_user.expenses.until_last_month.both_t.sum(:mypay) + partner.expenses.until_last_month.both_t.sum(:partnerpay)
  end

  def self.balance_of_gross(current_user, partner)
    my_gross = ones_gross(current_user)
    my_must_pay = must_pay(current_user, partner)
    balance = my_must_pay - my_gross + ones_all_payment(partner)
    return balance
  end

end
