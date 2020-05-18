class ApplicationController < ActionController::Base
  before_action :set_locale, :authenticate_user!, :set_search

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_url
  end

  def index; end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      home_path
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if current_user.present?

    store_location
    flash[:danger] = t "signin_require"
    redirect_to signin_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: User::ADDED_ATTRS
    devise_parameter_sanitizer.permit :account_update, keys: User::ADDED_ATTRS
  end

  def set_search
    @q = Doctor.ransack params[:q]
  end
end
