class SchedulesController < ApplicationController
  before_action :load_user, only: :index

  def index
    if current_user.patient?
      @appointment = @patient.appointments.includes(:doctor)
    else
      @appointment = @doctor.appointments.by_not_status(:canceled).includes(:patient)
    end
  end

  private

  def check_patient
    return unless current_user.patient?

    flash[:danger] = t "not_allowed"
    redirect_to root_path
  end

  def load_user
    if current_user.patient?
      return if @patient = Patient.find_by(id: params[:patient_id])

      flash[:danger] = t "not_found"
      redirect_to root_path
    else
      return if @doctor = Doctor.find_by(id: params[:doctor_id])

      flash[:danger] = t "not_found"
      redirect_to root_path
    end
  end
end
