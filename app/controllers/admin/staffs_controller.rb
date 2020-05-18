class Admin::StaffsController < Admin::BaseController
  before_action :load_staff, only: %i(edit update destroy)
  load_and_authorize_resource

  def index
    @q = Staff.ransack params[:q]
    @staffs = @q.result.order_by_name
                .page(params[:page]).per Settings.per_page
  end

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new staff_params
    ActiveRecord::Base.transaction do
      @staff.save!
      @staff.attach_image params, :staff
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
      @staff.update! staff_params
      @staff.attach_image params, :staff
    end
    flash[:success] = t "profile_updated"
    redirect_to admin_staffs_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_success"
    render :edit
  end

  def destroy
    if @staff.destroy
      flash[:success] = t "account_deleted"
    else
      flash[:danger] = t "not_success"
    end
    redirect_to admin_staffs_path
  end

  private

  def staff_params
    params.require(:staff).permit Staff::STAFF_PARAMS
  end

  def load_staff
    return if @staff = Staff.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to admin_staffs_path
  end
end
