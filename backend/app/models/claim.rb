class Claim < ApplicationRecord
  belongs_to :patient
  belongs_to :claim_import

  validates :claim_number, presence: true, uniqueness: true
  validates :service_date, presence: true
  validates :amount, presence: true, numericality: true
  validates :status, presence: true, inclusion: { in: %w[pending submitted denied paid] }
end
