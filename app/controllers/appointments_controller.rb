class AppointmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :new
  before_action :find_appointmentpointment, only: %i(update destroy)
  load_and_authorize_resource

  def new
    @appointment = Appointment.new
  end

  def index
    @appointments = Appointment.by_created_at.page(params[:page])
                               .per Settings.app_pages
  end

  def create
    params[:appointment][:end_time] =
      params[:appointment][:start_time].to_time(:utc).ago(Settings.limit_time)
    @appointment = current_user.appointments.build appointment_params
    created_appointment
  end

  def destroy
    if @appointment.destroy
      flash[:success] = t "appointment_canceled"
      redirect_to request.referer || root_url
    else
      flash[:danger] = t "not_success"
      redirect_to root_url
    end
  end

  def update
    if check_unduplicate_accepted
      @appointment.update(status:
      Appointment.statuses.key(params["appointment"]["status"].to_i))
      check_status
    elsif is_cancel_appointment?
      @appointment.cancel!
      flash[:success] = t "appointment_canceled"
    else
      flash[:danger] = t "already_have_an_appointment"
    end
    redirect_to appointments_path
  end

  private

  def appointment_params
    params.require(:appointment).permit Appointment::APPOINTMENT_PARAMS
  end

  def created_appointment
    if @appointment.save
      flash[:success] = t "appointment_created"
      redirect_to root_url
    else
      flash[:danger] = t "appointment_not_created"
      render :new
    end
  end

  def find_appointmentpointment
    @appointment = Appointment.find_by id: params[:id]
    return if @appointment

    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  def check_unduplicate_accepted
    Appointment.accept.appointment_exists(@appointment.doctor_id,
                                          @appointment.start_time,
                                          @appointment.day).blank?
  end

  def duplicate_waiting
    Appointment.waiting.appointment_exists(@appointment.doctor_id,
                                           @appointment.start_time,
                                           @appointment.day)
  end

  def check_status
    if params["appointment"]["status"] == Appointment.statuses[:accept].to_s
      duplicate_waiting.each do |ap|
        ap.update status: Appointment.statuses[:cancel]
      end

      flash[:success] = t "appointment_accepted"
    else
      flash[:success] = t "appointment_canceled"
    end
  end

  def is_cancel_appointment?
    params["appointment"]["status"] == Appointment.statuses[:cancel].to_s
  end
end
