class Admin::DoctorsController < Admin::BaseController
  before_action :load_doctor, only: %i(edit destroy update)
  load_and_authorize_resource

  def index
    @q = Doctor.ransack params[:q]
    @doctors = @q.result.order_by_name
                 .page(params[:page]).per Settings.page_size
  end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new doctor_params
    if @doctor.save
      @doctor.attach_image params, :doctor
      flash[:success] = t "create_account_success"
      redirect_to admin_doctors_path
    else
      flash[:danger] = t "not_create_success"
      render :new
    end
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @doctor.update! doctor_params
      @doctor.attach_image params, :doctor
    end
    flash[:success] = t "doctor_updated"
    redirect_to admin_doctors_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "doctor_not_success"
    render :edit
  end

  def destroy
    if @doctor.destroy
      flash[:success] = t "doctor_deleted"
    else
      flash[:danger] = t "doctor_not_deleted"
    end
    redirect_to admin_doctors_path
  end

  private

  def load_doctor
    return if @doctor = Doctor.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to doctors_path
  end

  def doctor_params
    params.require(:doctor).permit Doctor::DOCTOR_PARAMS
  end
end
