class Expense < ApplicationRecord
  has_one :category, dependent: :destroy
  belongs_to :user
end
