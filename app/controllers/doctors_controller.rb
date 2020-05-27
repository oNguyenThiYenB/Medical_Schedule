class DoctorsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :load_doctor, only: %i(show edit update)

  load_and_authorize_resource

  def index
    @doctors = @q.result.order_by_name
                 .page(params[:page]).per Settings.page_size
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @doctor.update! doctor_params
      @doctor.attach_image params, :doctor
    end
    flash[:success] = t "profile_updated"
    redirect_to @doctor
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_success"
    render :edit
  end

  def show; end

  private

  def doctor_params
    params.require(:doctor).permit Doctor::DOCTOR_PARAMS
  end

  def load_doctor
    return if @doctor = Doctor.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to doctors_path
  end
end
