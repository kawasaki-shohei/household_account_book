class Category < ApplicationRecord
  has_one :badget, dependent: :destroy

end
