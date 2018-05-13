class RepeatExpense < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :expenses, dependent: :destroy

  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(updated_at: :desc)}

  def self.ones_expenses(user)
    user.repeat_expenses.both_f.newer
  end

  def self.ones_expenses_of_both(user)
    user.repeat_expenses.both_t.newer
  end
end
