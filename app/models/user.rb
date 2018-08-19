class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true,
                    length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :partner_id, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  belongs_to :partner, class_name: 'User', optional: true, foreign_key: { to_table: :users }
  has_many :expenses, dependent: :destroy
  has_many :repeat_expenses, dependent: :destroy
  has_many :badgets, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :pays, dependent: :destroy
  has_many :wants, dependent: :destroy
  has_many :notifications, dependent: :destroy

end
