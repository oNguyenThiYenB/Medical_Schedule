class SendMessageJob < ApplicationJob
  queue_as :default

  def perform message
    # Do something later
    ActionCable.server.broadcast "conversations:#{message.receiver_id}", layout: render_message(message), receiver_id: message.receiver_id
  end

  private

  def render_message message
    ApplicationController.renderer.render(partial: "messages/message", locals: {message: message})
  end
end
