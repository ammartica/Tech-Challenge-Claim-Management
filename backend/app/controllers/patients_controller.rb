class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :update, :destroy]

  #get all patients
  def index
    render json: Patient.all
  end

  #get patient by id
  def show
    render json: @patient
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      render json: @patient, status: :created
    else
      render json: @patient.errors, status: :unprocessable_entity
    end
  end

  def update
    if @patient.update(patient_params)
      render json: @patient
    else
      render json: @patient.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    head :no_content
  end

  #helper methods
  private

  #basically data validation
  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :dob)
  end

  #loads patient based on id
  def set_patient
    @patient = Patient.find(params[:id])
  end

end