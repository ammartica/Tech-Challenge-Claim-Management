class ClaimImportsController < ApplicationController
  before_action :set_claim_import, only: [:show]

  # get all 
  def index
    render json: ClaimImport.includes(:claims).all
  end

  # get by id
  def show
    render json: @claim_import, include: :claims
  end

  #todo: add update to change claim status??

  # todo: this will be used to upload CSVs later
  def create
    @claim_import = ClaimImport.new(claim_import_params)
    if @claim_import.save
      render json: @claim_import, status: :created
    else
      render json: { errors: @claim_import.errors.full_messages }, status: :unprocessable_entity
    end
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

