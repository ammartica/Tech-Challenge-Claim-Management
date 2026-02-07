require 'csv'
require "fileutils"

class ClaimImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_claim_import, only: [:show]

  # get all 
  def index
    render json: ClaimImport.includes(:claims).all
  end

  # get by id
  def show
    render json: @claim_import, include: :claims
  end

  def create
    @claim_import = ClaimImport.new(claim_import_params)
    if @claim_import.save
      render json: @claim_import, status: :created
    else
      render json: { errors: @claim_import.errors.full_messages }, status: :unprocessable_entity
    end
  end


def import
  # Expecting file upload via params[:file]
  file = params[:file]
  # Make sure upload saves to required folder structure
  dir = Rails.root.join("claims_uploads", "imports", Date.current.to_s)
    FileUtils.mkdir_p(dir)
  timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
  stored_name = "claims_import_#{timestamp}.csv"
  stored_path = dir.join(stored_name)

  FileUtils.cp(file.path, stored_path)

  return render json: { error: "No file uploaded" }, status: :bad_request unless file

  # Create ClaimImport record
  claim_import = ClaimImport.create!(
    file_name: file.original_filename,
    total_records: 0,
    processed_records: 0,
    status: "pending"
  )

  # Process CSV rows
  processed = 0
  CSV.foreach(stored_path, headers: true) do |row|
    patient = Patient.find_or_create_by!(
      first_name: row['patient_first_name'],
      last_name:  row['patient_last_name'],
      dob:        row['patient_dob']
    )

    Claim.create!(
      claim_import: claim_import,
      patient:      patient,
      claim_number: row['claim_number'],
      service_date: row['service_date'],
      amount:       row['amount'],
      status:       row['status']
    )
    processed += 1
  end

  claim_import.update(total_records: processed, processed_records: processed, status: "completed")
  render json: { message: "CSV imported successfully", claim_import_id: claim_import.id }
rescue => e
  claim_import.update(status: "failed") if claim_import
  render json: { error: e.message }, status: :unprocessable_entity
end


  #helper methods
  private

  def claim_import_params
    params.require(:claim_import).permit(:file_name, :total_records, :processed_records, :status)
  end

  def set_claim_import
    @claim_import = ClaimImport.find(params[:id])
  end

end

