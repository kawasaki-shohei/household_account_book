class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true

  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.ones_all_payments(user)
    user.pays.all.sum(:pamount)
  end

  def self.total_amount(current_user)
    current_user.expenses.both_t.sum(:amount) + ones_all_payments(current_user)
  end

  def self.all_payments(current_user, partner)
    current_user.pays.or(partner.pays).newer
  end

  def self.balance_of_gross(current_user, partner)
    my_total_amount = total_amount(current_user)
    my_must_pay = Expense.must_pay(current_user, partner)
    my_all_pay = ones_all_payments(current_user)
    if my_total_amount > my_must_pay
      balance = my_must_pay - my_total_amount
    elsif my_total_amount < my_must_pay
      balance = my_must_pay - my_all_pay
    elsif my_total_amount == my_must_pay
      balance = 0
    end
    return balance
  end

end
