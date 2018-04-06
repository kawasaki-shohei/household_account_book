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

  def self.must_pay(current_user, partner)
    current_user.expenses.both_t.sum(:mypay) + partner.expenses.both_t.sum(:partnerpay)
  end

  def self.expense_in_both_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay) - current_user.expenses.this_month.both_t.sum(:amount)
  end

  def self.expense_in_both_last_month(current_user, partner)
    current_user.expenses.last_month.both_t.sum(:mypay) + partner.expenses.last_month.both_t.sum(:partnerpay) - current_user.expenses.last_month.both_t.sum(:amount)
  end

  def self.past_and_future(beginning_of_month, end_of_month)
    # 自分一人の出費
    @current_user_expenses = current_user.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_f.newer

    # 二人の出費の内、自分が払うもの、上記との違いはboth_flgのみ
    @current_user_expenses_of_both = current_user.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_t.newer

    # 相手が記入した二人の出費の内、自分が払うもの
    @partner_expenses_of_both = partner.expenses.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).both_t.newer
    common_variables(@current_user_expenses, @current_user_expenses_of_both, @partner_expenses_of_both)
  end

  def self.which_month_expense(cnum)
    if cnum < 0
      beginning_of_month = Date.today.months_ago(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_ago(@cnum.abs).end_of_month
    elsif cnum == 0
      redirect_to expenses_path
    elsif cnum > 0
      beginning_of_month = Date.today.months_since(@cnum.abs).beginning_of_month
      end_of_month = Date.today.months_since(@cnum.abs).end_of_month
    end
    past_and_future(beginning_of_month, end_of_month)
  end
end
