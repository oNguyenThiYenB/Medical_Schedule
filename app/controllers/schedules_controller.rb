class SchedulesController < ApplicationController
  before_action :check_patient, :load_doctor, only: :index

  def index
    @appointment = @doctor.appointments.accept.includes(:patient)
  end

  private

  def check_patient
    return unless current_user.patient?

    flash[:danger] = t "not_allowed"
    redirect_to root_path
  end

  def load_doctor
    return if @doctor = Doctor.find_by(id: params[:doctor_id])

    flash[:danger] = t "not_found"
    redirect_to appointments_path
  end
end
