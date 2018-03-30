class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true

  def self.balance_of_gross(current_user, partner)
    my_expenses = current_user.expenses.both_t.sum(:amount)
    partner_expenses = partner.expenses.both_t.sum(:partnerpay)
    all_payments = current_user.pays.all.sum(:pamount)
    balance = my_expenses - partner_expenses - all_payments
    return balance
  end

end
