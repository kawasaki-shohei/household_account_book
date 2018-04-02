class Expense < ApplicationRecord

  belongs_to :user
  has_one :category
  validates :amount, :date, presence: true

  end_of_month = Date.today.end_of_month
  beginning_of_month = Date.today.beginning_of_month
  end_of_last_month = Date.today.months_ago(1).end_of_month
  beginning_of_last_month = Date.today.months_ago(1).beginning_of_month
  scope :this_month, -> {where('date >= ? AND date <= ?', beginning_of_month, end_of_month)}
  scope :last_month, -> {where('date >= ? AND date <= ?', beginning_of_last_month, end_of_last_month)}
  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.current_user_expenses(current_user)
    current_user.expenses.this_month.both_f.newer
  end

  def self.current_user_expenses_of_both(current_user)
    current_user.expenses.this_month.both_t.newer
  end

  def self.partner_expenses_of_both(partner)
    partner.expenses.this_month.both_t.newer
  end

  def self.expense_in_both_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay) - current_user.expenses.this_month.both_t.sum(:amount)
  end

  def self.expense_in_both_last_month(current_user, partner)
    current_user.expenses.last_month.both_t.sum(:mypay) + partner.expenses.last_month.both_t.sum(:partnerpay) - current_user.expenses.last_month.both_t.sum(:amount)
  end
end
