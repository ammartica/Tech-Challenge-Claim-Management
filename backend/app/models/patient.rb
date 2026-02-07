class Patient < ApplicationRecord
  has_many :claims

  validates :first_name, :last_name, :dob, presence: true
end
