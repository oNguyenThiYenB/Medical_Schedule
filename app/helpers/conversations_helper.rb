module ConversationsHelper
  def load_messages conversation
    @messages = conversation.messages
  end

  def receiver_path receiver
    if current_user.nurse? || current_user.staff?
      receiver_path = patient_path(receiver.id)
    elsif current_user.patient? && receiver.nurse?
      # receiver_path = nurse_path(receiver.id)
      receiver_path = "#"
    else
      # receiver_path = staff_path(receiver.id)
      receiver_path = "#"
    end

    return receiver_path
  end
end
