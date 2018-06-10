class Expense < ApplicationRecord

  belongs_to :user
  has_one :category
  validates :amount, :date, presence: true
  validate :calculate_amount
  def calculate_amount
    if mypay != nil && partnerpay != nil && mypay + partnerpay != amount
      errors[:base] << "入力した金額の合計が支払い金額と一致しません"
    end
  end

  end_of_this_month = Date.today.end_of_month
  beginning_of_this_month = Date.today.beginning_of_month
  end_of_last_month = Date.today.months_ago(1).end_of_month
  beginning_of_last_month = Date.today.months_ago(1).beginning_of_month
  scope :this_month, -> {where('date >= ? AND date <= ?', beginning_of_this_month, end_of_this_month)}
  scope :last_month, -> {where('date >= ? AND date <= ?', beginning_of_last_month, end_of_last_month)}
  scope :until_last_month, -> {where('date <= ?', end_of_last_month)}
  scope :one_month, -> (begging_of_one_month, end_of_one_month) {where('date >= ? AND date <= ?', begging_of_one_month, end_of_one_month)}

  scope :extract_category, -> {unscope(:order).select(:category_id).distinct.pluck(:category_id)}
  scope :category, -> (category_id){unscope(:order).where(category_id: category_id).order(date: :desc, created_at: :desc)}
  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.ones_expenses(user)
    user.expenses.this_month.both_f.newer
  end

  def self.ones_expenses_of_both(user)
    user.expenses.this_month.both_t.newer
  end

  def self.must_pay_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay)
  end

  def self.category_sums(current_user_expenses, current_user_expenses_of_both, partner_expenses_of_both)
    category_ids = (current_user_expenses.extract_category + current_user_expenses_of_both.extract_category + partner_expenses_of_both.extract_category)
    if category_ids.present? && category_ids.size > 2 && (category_ids.count - category_ids.uniq.count) > 0
      category_ids.uniq!.sort!
    elsif category_ids.present?
      category_ids.sort!
    end
    category_sums = Hash.new
    category_ids.each do |category_id|
      category_sum = current_user_expenses.where(category_id: category_id).sum(:amount) + current_user_expenses_of_both.where(category_id: category_id).sum(:mypay) + partner_expenses_of_both.where(category_id: category_id).sum(:partnerpay)
      category_sums[category_id] = category_sum
    end
    return category_sums
  end


  def self.category_expense(current_user, partner, cnum, category)
    current_user_expenses = ShiftMonth.ones_expenses(current_user, cnum).category(category.id)
    current_user_expenses_of_both = ShiftMonth.ones_expenses_of_both(current_user, cnum).category(category.id)
    partner_expenses_of_both = ShiftMonth.ones_expenses_of_both(partner, cnum).category(category.id)
    both_sum = ShiftMonth.must_pay_one_month_one_category(current_user, partner, cnum, category)

    return current_user_expenses, current_user_expenses_of_both, partner_expenses_of_both, both_sum
  end



  def self.expense_in_both_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay) - current_user.expenses.this_month.both_t.sum(:amount)
  end

  def self.expense_in_both_last_month(current_user, partner)
    current_user.expenses.last_month.both_t.sum(:mypay) + partner.expenses.last_month.both_t.sum(:partnerpay) - current_user.expenses.last_month.both_t.sum(:amount)
  end

  def self.creat_repeat_expenses(s_date, r_date, e_date, repeat_expense, expense_params)
    (s_date..e_date).select{|d| d.day == r_date }.each do |date|
      expense = Expense.new(expense_params)
      expense.date = date
      expense.repeat_expense_id = repeat_expense.id
      expense.save
    end
  end

  def self.update_repeat_expense(old, repeat_expense, expense_params)
    today = Date.today
    old_s_date = old.s_date
    old_e_date = old.e_date
    old_r_date = old.r_date
    s_date = repeat_expense.s_date
    e_date = repeat_expense.e_date
    r_date = repeat_expense.r_date
    if today < s_date
      old_records = user.expenses.where(repeat_expense_id: repeat_expense.id)
      old_records.destroy_all
      creat_repeat_expenses(s_date, r_date, e_date, repeat_expense, expense_params)
    elsif today > e_date
      old_records = user.expenses.where('repeat_expense_id = ? AND date > ?', repeat_expense.id, e_date)
      old_records.destroy_all
    # elsif today > s_date && today < e_date

    end
  end

  def self.destroy_repeat_expenses(user, repeat_expense_id)
    expenses = user.expenses.where('repeat_expense_id = ? AND date >= ?', repeat_expense_id, Date.today.beginning_of_month)
    expenses.destroy_all
  end

end
