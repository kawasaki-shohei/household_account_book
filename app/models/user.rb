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
# **`name`**             | `string`           |
# **`password_digest`**  | `string`           |
# **`sys_admin`**        | `boolean`          | `default(FALSE)`
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
  has_many :wants, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :balances, dependent: :destroy

  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true,
            length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  with_options if: :partner_email_to_register do
    validate :check_valid_partner
  end

  after_update { build_couple.register_partner!(partner_email_to_register) if partner_email_to_register }

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

  def insert_expenses_for_a_month(year: Time.zone.today.year, month: Time.zone.today.month)
    @import_expenses = []
    partner = self.partner
    get_categories(partner).each do |category|
      p category
      count = get_count(category)
      build_expenses_instances(year, month, category.id, count, both_flg: category.common)
    end
    Expense.import(@import_expenses) ? true :false
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
    Category.import(@import_categories) ? true : false
  end

  def get_category(kind:)
    categories.find_by(kind: kind)
  end

  private

  def build_expenses_instances(year, month, category_id, count, both_flg:)
    today = Time.zone.today
    first = today.beginning_of_month.day
    last = today.end_of_month.day
    count.times do |n|
      amount = rand(100..10000)
      percent = count == 10 ? get_percent(n) : 1
      mypay = calculate_mypay(amount, percent)
      partnerpay = amount - mypay
      @import_expenses << expenses.build(
        amount: amount,
        date: Date.parse("#{year}-#{month}-#{rand(first..last)}"),
        note: "inserted #{today}",
        category_id: category_id,
        both_flg: both_flg,
        mypay: both_flg ? mypay : nil,
        partnerpay: both_flg ? partnerpay : nil,
        percent: both_flg ? percent : nil,
      )
    end
  end

  def get_percent(n)
    case n when 0..3 then 1 when 4..5 then 2 when 6..7 then 3 when 8..9 then 4 end
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
    case category.kind
    when "食費" then 10 when "日用品" then 5
    when "交通費", "交際費", "保険代", "医療費" then 2
    else 1
    end
  end

  def get_categories(partner)
    foods = get_category(kind: "食費")
    foods = partner.get_category(kind: "食費") unless foods
    goods = get_category(kind: "日用品")
    goods = partner.get_category(kind: "日用品") unless goods
    rent = get_category(kind: "家賃")
    rent = partner.get_category(kind: "家賃") unless rent
    gas = get_category(kind: "ガス代")
    gas = partner.get_category(kind: "ガス代") unless gas
    electricity = get_category(kind: "電気代")
    electricity = partner.get_category(kind: "電気代") unless electricity
    water = get_category(kind: "水道代")
    water = partner.get_category(kind: "水道代") unless water
    transportation = categories.find_by(kind: "交通費")
    entertainment = categories.find_by(kind: "交際費")
    insurance = categories.find_by(kind: "保険代")
    medical = categories.find_by(kind: "医療費")
    [foods, goods, rent, gas, electricity, water, transportation, entertainment, insurance, medical].compact
  end

  def create_category_instance(kinds, user, common_flg)
    kinds.each do |kind|
      @import_categories << Category.new(
        kind: kind,
        user_id: user.id,
        common: common_flg
      )
    end
  end

end
