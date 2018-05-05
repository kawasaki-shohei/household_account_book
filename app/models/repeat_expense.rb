class RepeatExpense < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :expenses, dependent: :destroy
end
