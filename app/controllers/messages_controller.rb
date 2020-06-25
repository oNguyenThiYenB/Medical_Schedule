class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find_by(id: params[:conversation_id])
    check_receiver = @conversation.patient_id == params[:sender_id].to_i ? @conversation.host_id : @conversation.patient_id
    @message = @conversation.messages.create(body: params[:body], sender_id: params[:sender_id], receiver_id: check_receiver)
    SendMessageJob.perform_now(@message, params[:sender_id])
    session[:current_user] = current_user.id
    respond_to :js
  end
end
