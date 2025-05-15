class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar # using Active Storage for file uploads

  validates :email, :username, presence: true, uniqueness: true
end
