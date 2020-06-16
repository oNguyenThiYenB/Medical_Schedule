module ConversationsHelper
  def load_messages conversation
    @messages = conversation.messages
  end
end
