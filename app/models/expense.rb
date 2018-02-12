class Expense < ApplicationRecord
  has_one :category, dependent: :destroy
  has_one :how_much, dependent: :destroy
  belongs_to :user
end
