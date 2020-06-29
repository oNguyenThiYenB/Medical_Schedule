class AppointmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(new for_faculty_id for_doctor_id for_date_picker)
  before_action :find_appointment, only: %i(update destroy)
  load_and_authorize_resource

  include AppointmentHelper

  def new
    @appointment = Appointment.new
  end

  def index
    @appointments = Appointment.by_created_at.page(params[:page])
                               .per Settings.app_pages
  end

  def create
    # params[:appointment][:end_time] =
    #   params[:appointment][:start_time].to_time(:utc).ago(Settings.limit_time)
    @appointment = current_user.appointments.build appointment_params
    created_appointment
    MailCreatedAppointmentJob.perform_later @appointment
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
    MailAppointmentResultJob.perform_later @appointment
    if @appointment.accept?
      byebug
      MailIncomingAppointmentJob.set(wait_until: @appointment.day.to_time(:utc).ago(Settings.remind_time)).perform_later @appointment
    end

    redirect_to appointments_path
  end

  def for_faculty_id
    @doctors = Doctor.includes(:doctor_faculties).where("doctor_faculties.faculty_id = ?", params[:faculty_id]).references(:doctor_faculties)
    respond_to do |format|
      format.json  { render :json => @doctors }
    end
  end

  def for_doctor_id
    # @not_confirmed = [:waiting, :cancle]
    current_date = Date.today
    occupied_full_dates = Appointment.find_appointments_by_doctor_id_from_current_date(params[:doctor_id], current_date)&.
    by_not_confirmed([:waiting, :cancle])&.group(:day).count.select { |day, count| count == 16 }.keys
    @occupied_full_dates_formated = occupied_full_dates_formated(occupied_full_dates)
    respond_to do |format|
      format.json  { render :json => @occupied_full_dates_formated }
    end
  end

  def for_date_picker
    occupied_appointments_by_day = Appointment.find_appointments_by_doctor_id_and_day(params[:doctor_id], params[:date_picker].to_date)&.
    by_not_confirmed([:waiting, :cancle])
    if occupied_appointments_by_day.present?
      shift_work_id_arr = occupied_appointments_by_day.map do
        |appointment| appointment.shift_work_id
      end
      free_shift_works_by_day = ShiftWork.by_shift_work_id(shift_work_id_arr)
    else
      free_shift_works_by_day = ShiftWork.all
    end
    @free_time_by_day = time_format(free_shift_works_by_day)
    respond_to do |format|
      format.json  { render :json => @free_time_by_day }
    end
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

  def find_appointment
    @appointment = Appointment.find_by id: params[:id]
    return if @appointment

    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  def check_unduplicate_accepted
    Appointment.accept.appointment_exists(@appointment.doctor_id,
                                          @appointment.day,
                                          @appointment.shift_work_id).blank?
  end

  def duplicate_waiting
    Appointment.waiting.appointment_exists(@appointment.doctor_id,
                                            @appointment.day,
                                            @appointment.shift_work_id)
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
