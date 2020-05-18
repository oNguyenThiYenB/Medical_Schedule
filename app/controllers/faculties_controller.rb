class FacultiesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :load_faculty, only: :show
  def index
    @faculties = Faculty.order_by_name.page(params[:page]).per Settings.page_size
  end

  def show; end

  private

  def load_faculty
    return if @faculty = Faculty.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to root_url
  end
end
