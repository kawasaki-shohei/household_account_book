class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true

  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.all_payments(current_user, partner)
    current_user.pays.or(partner.pays).newer
  end

  def self.balance_of_gross(current_user, partner)
    my_expenses = current_user.expenses.both_t.sum(:mypay) + partner.expenses.both_t.sum(:partnerpay)
    current_user_payments = current_user.pays.sum(:pamount)
    partner_payments = partner.pays.sum(:pamount)
    balance = my_expenses + current_user_payments - partner_payments
    return balance
  end

end
