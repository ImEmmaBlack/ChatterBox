class User < ApplicationRecord
  has_secure_password
  has_many :participants
  has_many :conversations, through: :participants

  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :email, presence: true, uniqueness: true, email_format: { message: 'must be valid email' }
end
