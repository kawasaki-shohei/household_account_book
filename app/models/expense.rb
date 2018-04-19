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
  scope :one_month, -> (begging_of_one_month, end_of_one_month) {where('date >= ? AND date <= ?', begging_of_one_month, end_of_one_month)}

  scope :extract_category, -> {unscope(:order).select(:category_id).distinct.pluck(:category_id)}
  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(date: :desc, created_at: :desc)}

  # def self.current_user_expenses(current_user)
  #   current_user.expenses.this_month.both_f.newer
  # end
  def self.ones_expenses(user)
    user.expenses.this_month.both_f.newer
  end

  # def self.current_user_expenses_of_both(current_user)
  #   current_user.expenses.this_month.both_t.newer
  # end
  def self.ones_expenses_of_both(user)
    user.expenses.this_month.both_t.newer
  end

  def self.partner_expenses_of_both(partner)
    partner.expenses.this_month.both_t.newer
  end

  def self.must_pay_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay)
  end

  def self.category_sums(current_user_expenses, current_user_expenses_of_both, partner_expenses_of_both)
    category_ids = (current_user_expenses.extract_category + current_user_expenses_of_both.extract_category + partner_expenses_of_both.extract_category)
    if category_ids.present?
      category_ids.uniq!.sort!
    end
    category_sums = Hash.new
    category_ids.each do |category_id|
      category_sum = current_user_expenses.where(category_id: category_id).sum(:amount) + current_user_expenses_of_both.where(category_id: category_id).sum(:mypay) + partner_expenses_of_both.where(category_id: category_id).sum(:partnerpay)
      category_sums[category_id] = category_sum
    end
    return category_sums
  end




  def self.expense_in_both_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay) - current_user.expenses.this_month.both_t.sum(:amount)
  end

  def self.expense_in_both_last_month(current_user, partner)
    current_user.expenses.last_month.both_t.sum(:mypay) + partner.expenses.last_month.both_t.sum(:partnerpay) - current_user.expenses.last_month.both_t.sum(:amount)
  end


end
