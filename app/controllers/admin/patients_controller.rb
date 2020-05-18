class Admin::PatientsController < Admin::BaseController
  before_action :load_patient, only: %i(edit update destroy)
  load_and_authorize_resource

  def index
    @q = Patient.ransack params[:q]
    @patients = @q.result.order_by_name
                  .page(params[:page]).per Settings.per_page
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new patient_params
    ActiveRecord::Base.transaction do
      @patient.save!
      @patient.attach_image params, :patient
    end
    flash[:success] = t "create_account_success"
    redirect_to admin_staffs_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_success"
    render :new
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @patient.update! patient_params
      @patient.attach_image params, :patient
      @patient.attach_file params
    end
    flash[:success] = t "profile_updated"
    redirect_to admin_patients_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_success"
    render :edit
  end

  def destroy
    if @patient.destroy
      flash[:success] = t "account_deleted"
    else
      flash[:danger] = t "not_success"
    end
    redirect_to admin_patients_path
  end

  private

  def patient_params
    params.require(:patient).permit Patient::PATIENT_PARAMS
  end

  def load_patient
    return if @patient = Patient.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to admin_patients_path
  end
end
