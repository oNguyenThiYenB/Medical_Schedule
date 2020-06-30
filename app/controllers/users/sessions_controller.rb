class Users::SessionsController < Devise::SessionsController
  before_action :save_path, only: :new

  private

  def save_path
    session[:saved_path] = request.referrer
  end
end
