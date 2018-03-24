class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true
end
