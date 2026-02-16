class Claim < ApplicationRecord
  belongs_to :patient #each claim has patient
  belongs_to :claim_import #each claim has an import

  #must exist, cannot duplicate
  validates :claim_number, presence: true, uniqueness: true
  #req field
  validates :service_date, presence: true
  #req field and must be number
  validates :amount, presence: true, numericality: true
  #req field and only allows specific values
  validates :status, presence: true, inclusion: { in: %w[pending submitted denied paid] }
end
