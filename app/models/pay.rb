class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true

  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.all_payments(current_user, partner)
    current_user.pays.or(partner.pays).newer
  end

  def self.balance_of_gross(current_user, partner)
    my_expenses = current_user.expenses.both_t.sum(:amount)
    partner_expenses = partner.expenses.both_t.sum(:mypay) + current_user.expenses.both_t.sum(:partnerpay)
    all_payments = partner.pays.all.sum(:pamount)
    balance = my_expenses - partner_expenses - all_payments
    return balance
  end

end
