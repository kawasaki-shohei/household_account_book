# ## Schema Information
#
# Table name: `expenses`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint(8)`        | `not null, primary key`
# **`amount`**             | `integer`          |
# **`both_flg`**           | `boolean`          | `default(FALSE)`
# **`date`**               | `date`             |
# **`memo`**               | `string`           |
# **`mypay`**              | `integer`          |
# **`partnerpay`**         | `integer`          |
# **`percent`**            | `integer`          | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`category_id`**        | `integer`          |
# **`repeat_expense_id`**  | `bigint(8)`        |
# **`user_id`**            | `integer`          |
#
# ### Indexes
#
# * `index_expenses_on_repeat_expense_id`:
#     * **`repeat_expense_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`repeat_expense_id => repeat_expenses.id`**
#

class Expense < ApplicationRecord
  include BalanceHelper

  belongs_to :user
  belongs_to :category

  before_validation :set_mypay_and_partnerpay

  validates :amount, :date, presence: true
  validates_length_of :amount, :mypay, :partnerpay, maximum: 10
  validates_length_of :memo, maximum: 100
  validates :percent, presence: true
  validate :calculate_amount

  # todo: これはテーブルを作ってユーザーが自由に変更できるようにする。
  enum percent: { manual_amount: -1, pay_all: 0, pay_half: 1, pay_one_third: 2, pay_two_thirds: 3, pay_nothing: 4 }

  end_of_this_month = Date.today.end_of_month
  beginning_of_this_month = Date.today.beginning_of_month
  end_of_last_month = Date.today.months_ago(1).end_of_month
  beginning_of_last_month = Date.today.months_ago(1).beginning_of_month
  scope :this_month, -> {where('date >= ? AND date <= ?', beginning_of_this_month, end_of_this_month)}
  scope :last_month, -> {where('date >= ? AND date <= ?', beginning_of_last_month, end_of_last_month)}
  scope :until_last_month, -> {where('date <= ?', end_of_last_month)}
  # 引数はString。 例: "2019-01"
  scope :one_month, -> (period) {where('date >= ? AND date <= ?', period.to_beginning_of_month, period.to_end_of_month)}
  scope :except_repeat_ones, -> {where.not()}
  scope :category, -> (category_id){unscope(:order).where(category_id: category_id).order(date: :desc, created_at: :desc)}
  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(date: :desc, created_at: :desc)}

  attr_accessor :is_new, :is_destroyed, :differences
  alias_method :is_new?, :is_new
  alias_method :is_destroyed?, :is_destroyed
  alias_attribute :is_for_both?, :both_flg

  after_initialize { self.is_new = true unless self.id }
  before_save :set_differences
  before_destroy { self.is_destroyed = true }
  after_commit { go_calculate_balance(self) }

  # 金額に関するカラムを配列で返す。
  def self.money_attributes
    %w(amount mypay partnerpay)
  end

  # @param [User] user
  # @param [String] period "2019-02"
  # @return [Expense]
  def self.all_for_one_month(user, period)
    partner = user.partner
    self.includes(:user, :category).references(:users, :categories).where(users: {id: [user, partner]}).one_month(period)
  end

  # @note 該当月と引数のカテゴリの出費でユーザーの全ての出費とパートナーの二人の出費を取得
  # @param [User] user
  # @param [Category] category
  # @param [String] period "2019-02"
  # @return [Expense]
  def self.specified_category_for_one_month(user, category, period)
    partner = user.partner
    self.includes(:user, :category).references(:users, :categories).where(categories: {id: category}).one_month(period).where("users.id = ? OR (users.id = ? AND both_flg = ?)", user.id, partner.id, true).order(date: :desc, created_at: :desc)
  end

  def set_mypay_and_partnerpay
    return if !is_for_both?
    case percent
    when "pay_all"
      self.mypay = amount
      self.partnerpay = 0
    when "pay_half"
      self.mypay = (amount / 2).round
      self.partnerpay = (amount - mypay)
    when "pay_one_third"
      self.mypay = (amount / 3).round
      self.partnerpay = (amount - mypay)
    when "pay_two_thirds"
      self.mypay = (amount * 2 / 3).round
      self.partnerpay = (amount - mypay)
    when "pay_nothing"
      self.mypay = 0
      self.partnerpay = amount
    end
  end

  def calculate_amount
    return unless is_for_both?
    if mypay.nil? || partnerpay.nil? || mypay + partnerpay != amount
      errors[:base] << "入力した金額の合計が支払い金額と一致しません"
    end
  end

  # ユーザーと該当月からその月の支出合計額を算出
  # @param user: Userクラス, month: Stringクラス "2019-01"
  # @return Integer 支出合計額
  def self.one_month_total_expenditures(user, period)
    # 自分の一人の出費の支払い額(amount)の合計額 + 自分の二人の出費の自分の支払い分(mypay)の合計額 + パートナーの二人の出費のパートナーの支払い分(partner)の合計額
    user_expenses = user.expenses.one_month(period)
    user_expenses.both_f.sum(:amount) + user_expenses.both_t.sum(:mypay) + user.partner.expenses.one_month(period).both_t.sum(:partnerpay)
  end

  def is_own_expense?(user, category)
    !is_for_both? && self.user == user && self.category == category
  end

  def is_both_expense_paid_by?(user, category)
    is_for_both? && self.user == user && self.category == category
  end

















  # fixme: case文でsqlのwarningが出ているので、要修正
  # viewで出費リストを表示するために、並び替えを行うメソッド
  # @param [boolean] both_flg 二人のための出費ならtrue, 自分だけのためのフラグならfalse
  # @return 基本的には新しいものが上に表示されるようにしているが、繰り返し出費で入力されたものは、普通の出費が全て表示された後に表示されるように並び替えている
  def self.arrange(both_flg)
    expenses = both_flg ? self.both_t : self.both_f
    ids = expenses.where(repeat_expense_id: nil).newer.map{|i| i.id}
    repeat_ones = expenses.where.not(repeat_expense_id: nil).newer.map{|i| i.id}
    unless repeat_ones[0] == nil
      ids += repeat_ones
    end
    order_condition = "CASE id "
    ids.each_with_index do |id, index|
      order_condition << sanitize_sql_array(["WHEN ? THEN ? ", id, index])
    end
    order_condition << sanitize_sql_array(["ELSE ? END", ids.length])
    if ids.empty?
      self.where(id: ids)
    else
      self.where(id: ids).order(order_condition)
    end
  end

  # fixme: this occur n+1
  # 手渡し料金表示画面で今月の料金を計算するメソッド
  def self.both_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay) - current_user.expenses.this_month.both_t.sum(:amount)
  end

  # fixme: this occur n+1
  # 手渡し料金表示画面で先月の料金を計算するメソッド
  def self.both_last_month(current_user, partner)
    current_user.expenses.last_month.both_t.sum(:mypay) + partner.expenses.last_month.both_t.sum(:partnerpay) - current_user.expenses.last_month.both_t.sum(:amount)
  end

  # 新しく繰り返し出費が登録されたときに、expensesテーブルに該当する出費をインサートしていくメソッド
  def self.creat_repeat_expenses(repeat_expense, expense_params)
    s_date = repeat_expense.s_date
    e_date = repeat_expense.e_date
    r_date = repeat_expense.r_date
    (s_date..e_date).select{|d| d.day == r_date }.each do |date|
      expense = Expense.new(expense_params)
      expense.date = date
      expense.repeat_expense_id = repeat_expense.id
      expense.save
    end
  end

  # 繰り返し出費の更新のときのためのメソッド。方針が決まらず、途中
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

  # 繰り返し出費を消したときのそれに紐づいているexpensesを消去するメソッド
  # 当月以降のexpensesは消去。当月以前のexpensesは残す
  def self.destroy_repeat_expenses(user, repeat_expense_id)
    future_expenses = user.expenses.where('repeat_expense_id = ? AND date >= ?', repeat_expense_id, Date.today.beginning_of_month)
    future_expenses.destroy_all
    past_expenses = user.expenses.where('repeat_expense_id = ? AND date <= ?', repeat_expense_id, Date.today.beginning_of_month)
    past_expenses.update(repeat_expense_id: nil)
  end

end
