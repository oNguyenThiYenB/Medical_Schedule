class Users::RegistrationsController < Devise::RegistrationsController
  after_action :attach_image, only: %i(create update)
  after_action :attach_file, only: :update

  def create
    super
  end

  def update
    super
  end

  private

  def attach_image
    return if resource.attach_image params, :user

    flash[:danger] = t "not_sucess"
    render :new
  end

  def attach_file
    return if resource.files.attach(params[:user][:file])

    flash[:danger] = t "not_sucess"
    render :new
  end
end
