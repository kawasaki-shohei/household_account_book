class Expense < ApplicationRecord
  belongs_to :user
  has_one :category
  validates :amount, :date, presence: true

  end_of_month = Date.today.end_of_month
  beginning_of_month = Date.today.beginning_of_month
  scope :this_month, -> {where('date >= ? AND date <= ?', beginning_of_month, end_of_month)}
  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(date: :desc, created_at: :desc)}
end
