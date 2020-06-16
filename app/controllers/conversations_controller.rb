class ConversationsController < ApplicationController
  before_action :load_conversation, only: :show
  def index
    # byebug
    # session[:conversations] ||= []
    if (current_user&.nurse? || current_user&.staff?)
      @users = Patient.all.order_by_name
    else
      @users = User.all.where(role: [:nurse, :staff]).order_by_name
    end
    respond_to :js
  end

  def show
    @messages = Message.all
  end

  def create
    if current_user&.patient?
      host_id = params[:user_id].to_i
      patient_id = current_user.id
    else
      patient_id = params[:user_id].to_i
      host_id = current_user.id
    end
    @conversation = Conversation.find_or_create_by(host_id: host_id, patient_id: patient_id)
    respond_to :js
  end

  def close
    @conversation = Conversation.find(params[:id])

    session[:conversations].delete(@conversation.id)

    respond_to do |format|
      format.js
    end
  end

  private

  def add_to_conversations
    session[:conversations] ||= []
    session[:conversations] << @conversation.id
  end

  def conversated?
    session[:conversations].include?(@conversation.id)
  end

  def load_conversation
    byebug
    return if @conversation = Conversation.find_by(id: params[:conversation_id])

    flash[:danger] = t "not_found"
  end
end
