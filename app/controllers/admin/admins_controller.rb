class Admin::AdminsController < Admin::BaseController
  before_action :load_admin, only: %i(edit update destroy)
  load_and_authorize_resource

  def index
    @q = Admin.ransack(params[:q])
    @admins = @q.result.order_by_name
                .page(params[:page]).per Settings.per_page
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new admin_params
    ActiveRecord::Base.transaction do
      @admin.save!
      @admin.attach_image params, :admin
    end
    flash[:success] = t "create_account_success"
    redirect_to admin_admins_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_success"
    render :new
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @admin.update! admin_params
      @admin.attach_image params, :admin
    end
    flash[:success] = t "profile_updated"
    redirect_to admin_admins_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_success"
    render :edit
  end

  def destroy
    if @admin.destroy
      flash[:success] = t "account_deleted"
    else
      flash[:danger] = t "not_success"
    end
    redirect_to admin_admins_path
  end

  private

  def admin_params
    params.require(:admin).permit Admin::ADMIN_PARAMS
  end

  def load_admin
    return if @admin = Admin.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to admin_admins_path
  end
end
