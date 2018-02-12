class Expense < ApplicationRecord
  has_one :devide, dependent: :destroy
  accepts_nested_attributes_for :devide
  belongs_to :user
end
