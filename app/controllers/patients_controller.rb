class PatientsController < ApplicationController
  skip_before_action :authenticate_user!, except: %i(index show)
  skip_before_action :set_search
  before_action :set_search_patient
  before_action :find_patient, only: :show

  load_and_authorize_resource

  def index
    @patients = @q.result.order_by_name
                  .page(params[:page]).per Settings.page_size
  end

  def show; end

  private

  def find_patient
    return if @patient = Patient.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  def set_search_patient
    @q = Patient.ransack params[:q]
  end
end
