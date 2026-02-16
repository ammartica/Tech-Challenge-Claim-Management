class User < ApplicationRecord
  #uses bcrypt
  #stores password as password_digest
  #adds .authenticate
  #automatically hashes passwords
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: %w[admin staff] }
end
