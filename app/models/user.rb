# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint(8)`        | `not null, primary key`
# **`allow_share_own`**  | `boolean`          | `default(FALSE)`
# **`email`**            | `string`           |
# **`is_demo_user`**     | `boolean`          | `default(FALSE)`
# **`name`**             | `string`           |
# **`password_digest`**  | `string`           |
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_users_on_email` (_unique_):
#     * **`email`**
#

class User < ApplicationRecord

  attr_accessor :partner_email_to_register

  has_one :couple
  has_one :partner, through: :couple
  has_many :expenses, dependent: :destroy
  has_many :repeat_expenses, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :pays, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :balances, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/i
  validates :name,  presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validate :password_complexity
  with_options if: :partner_email_to_register do
    validate :check_valid_partner
  end

  after_update { build_couple.register_partner!(partner_email_to_register) if partner_email_to_register }

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
    errors.add(:password, I18n.t('user.validation.weak_password'))
  end

  def check_valid_partner
    unless pre_partner = User.find_by(email: partner_email_to_register)
      errors[:base] << '入力いただいたメールアドレスのユーザーはご登録されていないため、パートナーとして登録できません。'
      return
    end
    if pre_partner.partner
      errors[:base] << '入力いただいたメールアドレスのユーザーは、すでにあなた以外のパートナーが登録されているため、パートナーとして登録できません。'
    end
  end

  def get_applicable_balance(period)
    balances.where(period: period).first_or_initialize
  end

  def insert_categories
    both_kinds = %w(家賃 食費 日用品 ガス代 電気代 水道代)
    ones_kinds = %w(交通費 交際費 保険代 医療費)
    user = self
    partner = user.partner
    @import_categories = []

    create_category_instance(both_kinds, user, true)
    create_category_instance(ones_kinds, user, false)
    create_category_instance(ones_kinds, partner, false)
    @import_categories.each(&:save!)
  end

  def get_category(name:)
    categories.find_by_name(name)
  end

  def insert_expenses_for_a_month(year: Time.zone.today.year, month: Time.zone.today.month)
    import_expenses = []
    partner = self.partner
    get_categories(partner).each do |category|
      count = get_count(category)
      count.times do
        import_expenses << build_expenses_instances(year, month, category, is_for_both: true)
      end
    end
    import_expenses.each(&:save!)
  end

  def build_expenses_instances(year, month, category, is_for_both: false)
    today = Time.zone.today
    first_day = Date.new(year, month, 1)
    last_day = first_day.end_of_month
    expense = expenses.build(
      amount: Faker::Number.number(5),
      date: Faker::Date.between(first_day, last_day),
      memo: "random sample expense inserted at #{I18n.l(today, format: :default)}",
      category_id: category.id,
      is_for_both: is_for_both,
      percent: is_for_both ? get_random_percent : 0,
      )
    if expense.manual_amount?
      expense.mypay = Faker::Number.between(1, expense.amount - 1)
      expense.partnerpay = expense.amount - expense.mypay
    end
    expense
  end

  private

  def get_random_percent
    Expense.percents.sort_by{rand}[0][0]
  end

  def calculate_mypay(amount, percent)
    case percent
    when 1 then amount / 2
    when 2 then amount / 3
    when 3 then amount * 2 / 3
    when 4 then 0
    end
  end

  def get_count(category)
    case category.name
    when "食費" then 10
    when "日用品" then 5
    when "交通費", "交際費", "保険代", "医療費" then 2
    else 1
    end
  end

  def get_categories(partner)
    foods = get_category(name: "食費")
    foods = partner.get_category(name: "食費") unless foods
    goods = get_category(name: "日用品")
    goods = partner.get_category(name: "日用品") unless goods
    rent = get_category(name: "家賃")
    rent = partner.get_category(name: "家賃") unless rent
    gas = get_category(name: "ガス代")
    gas = partner.get_category(name: "ガス代") unless gas
    electricity = get_category(name: "電気代")
    electricity = partner.get_category(name: "電気代") unless electricity
    water = get_category(name: "水道代")
    water = partner.get_category(name: "水道代") unless water
    transportation = categories.find_by(name: "交通費")
    entertainment = categories.find_by(name: "交際費")
    insurance = categories.find_by(name: "保険代")
    medical = categories.find_by(name: "医療費")
    [foods, goods, rent, gas, electricity, water, transportation, entertainment, insurance, medical].compact
  end

  def create_category_instance(kinds, user, is_common)
    kinds.each do |kind|
      @import_categories << Category.new(
        name: kind,
        user_id: user.id,
        is_common: is_common
      )
    end
  end

end
