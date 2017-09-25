class User < ApplicationRecord
  has_secure_password
  has_many :participants
  has_many :conversations, through: :participants
  fuzzily_searchable :username
end
