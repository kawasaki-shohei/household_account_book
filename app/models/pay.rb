class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true

  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.ones_gross(user)
    user.expenses.both_t.sum(:amount) + user.pays.all.sum(:pamount)
  end

  def self.all_payments(current_user, partner)
    current_user.pays.or(partner.pays).newer
  end

  def self.balance_of_gross(current_user, partner)
    my_gross = ones_gross(current_user)
    my_must_pay = Expense.must_pay(current_user, partner)
    balance = my_must_pay - my_gross
    return balance
  end

end
