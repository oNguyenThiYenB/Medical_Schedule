module MessagesHelper
  def message_class message
    session[:current_user] == message.sender_id ? "message-sent" : "message-received"
  end

  def message_image message
    message_type = session[:current_user] == message.sender_id ? "message-sent" : "message-received"
    if message_type == "message-sent"
      message_image = current_user.image
    else
      message_image = User.find_by_id(message.receiver_id).image
    end
     return message_image
  end
end
