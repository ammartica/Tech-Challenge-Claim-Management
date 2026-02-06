require "csv"

class ClaimsController < ApplicationController
  before_action :set_claim, only: [:show, :update, :destroy]

  # get all
  def index
    render json: Claim.includes(:patient, :claim_import).all
  end

  # get by id
  def show
    render json: @claim
  end

  def create
    @claim = Claim.new(claim_params)
    if @claim.save
      render json: @claim, status: :created
    else
      render json: { errors: @claim.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @claim.update(claim_params)
      render json: @claim
    else
      render json: { errors: @claim.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @claim.destroy
    head :no_content
  end

  def export
  claims = Claim.includes(:patient).order(created_at: :desc)

  csv_data = CSV.generate(headers: true) do |csv|
    csv << ["claim_number", "patient_name", "service_date", "amount", "status"]

    claims.find_each do |claim|
      csv << [
        claim.claim_number,
        "#{claim.patient.first_name} #{claim.patient.last_name}",
        claim.service_date,
        claim.amount,
        claim.status
      ]
    end
  end

  send_data csv_data,
            filename: "claims_export_#{Time.now.strftime('%Y%m%d_%H%M%S')}.csv",
            type: "text/csv"
end

  #helper methods
  private

  #basically data validation
  def claim_params
    params.require(:claim).permit(:patient_id, :claim_import_id, :claim_number, :service_date, :amount, :status)
  end

  #get claim by id
  def set_claim
    @claim = Claim.find(params[:id])
  end

end
