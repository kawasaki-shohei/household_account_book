class Category < ApplicationRecord
  belongs_to :user
  has_one :badget, dependent: :destroy
  has_many :expenses

  scope :oneself, -> {where(common: false)}
  scope :common_t, -> {where(common: true)}

  validates :kind, presence: true

  def self.ones_categories(current_user, partner)
    current_user.categories.or(partner.categories.where(common: true))
  end
end
