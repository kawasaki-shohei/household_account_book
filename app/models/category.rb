class Category < ApplicationRecord
  belongs_to :user
  has_one :badget, dependent: :destroy
  has_many :expenses

  scope :oneself, -> {where(common: false)}

  validates :kind, presence: true

end
