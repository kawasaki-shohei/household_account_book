class Category < ApplicationRecord
  belongs_to :user
  has_one :badget, dependent: :destroy


end
