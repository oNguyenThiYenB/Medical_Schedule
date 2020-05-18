class Admin::BaseController < ApplicationController
  before_action :authenticate_user!, :is_admin?
  layout "admins"

  private

  def is_admin?
    return if current_user.admin?

    redirect_to root_url
    flash[:warning] = t "you_are_not_authorized_to_access_this_page"
  end
end
