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

  #claimImport is my activerecord model (represents claim_imports table in my db)
  #.new and .save methods that build and persist to the db
  #
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
  #frontend sends rails makes it available else error
  file = params[:file]
    return render json: { error: "No file uploaded" }, status: :bad_request unless file
  # Make sure upload saves to required folder structure
  #this joins paths and makes the directory (/claims_uploads/imports/yyyy-mm-dd)
  dir = Rails.root.join("claims_uploads", "imports", Date.current.to_s)
    FileUtils.mkdir_p(dir)
  timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
  stored_name = "claims_import_#{timestamp}.csv"
  stored_path = dir.join(stored_name)

  #this copies uploaded temp file into permanent structured folder
  FileUtils.cp(file.path, stored_path)

  # Create ClaimImport record
  claim_import = ClaimImport.create!(
    file_name: file.original_filename,
    total_records: 0,
    processed_records: 0,
    status: "pending"
  )

  # Process CSV rows
  total = 0
  processed = 0
  errors = []

  #for each row 
  CSV.foreach(stored_path, headers: true) do |row|
    total +=  #incrememnt counter
    begin
      # Removes spaces from header
      data = row.to_h.transform_keys { |k| k.to_s.strip } 
      #create find or create patient
      patient = Patient.find_or_create_by!(
        first_name: data["patient_first_name"],
        last_name:  data["patient_last_name"],
        dob:        data["patient_dob"]
      )
      #create claim
      Claim.create!(
        claim_import: claim_import,
        patient:      patient,
        claim_number: data["claim_number"],
        service_date: data["service_date"],
        amount:       data["amount"],
        status:       data["status"]
      )

      processed += 1
      #if row fails, rescue error, log it, and continue so the import doesnt stop
    rescue => e
      errors << { row: total, error: e.message }
      Rails.logger.warn("Import row #{total} skipped: #{e.message}")
    end
  end
  #after loop ends, check total rows, process successfully, and check status
  claim_import.update!(
    total_records: total,
    processed_records: processed,
    status: "completed"
  )

  render json: {
  message: "CSV imported successfully",
  claim_import_id: claim_import.id,
  total: total,
  processed: processed,
  skipped: total - processed,
  errors: errors.first(20)
  }
  rescue => e
  claim_import.update(status: "failed") if defined?(claim_import) && claim_import
  render json: { error: e.message }, status: :unprocessable_entity
end

  #helper methods
  private

  #params is a ruby object (data from http request)
  #require ensures requests contains a claim_import object
  #permit... allows only those fields to be used
  def claim_import_params
    params.require(:claim_import).permit(:file_name, :total_records, :processed_records, :status)
  end

  #finds claimimport by the id from the url
  def set_claim_import
    @claim_import = ClaimImport.find(params[:id])
  end

end
