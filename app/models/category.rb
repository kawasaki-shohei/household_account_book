class Category < ApplicationRecord
  belongs_to :user
  has_one :badget, dependent: :destroy
  has_many :expenses

  scope :oneself, -> {where(common: false)}


end
