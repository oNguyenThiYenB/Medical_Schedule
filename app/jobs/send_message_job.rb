class SendMessageJob < ApplicationJob
  queue_as :default

  def perform message, sender_id
    # Do something later
    renderer = ApplicationController.renderer.new(
      http_host: ENV['RAILS_APPLICATION_URL'].presence || 'http://localhost:3000' ,
      https:      Rails.env.production?
    )

    # ActionCable.server.broadcast "stream:#{chat_message.stream.id}", {
    #     chat_message: renderer.render(chat_message)
    # }
    ActionCable.server.broadcast "conversations:#{message.receiver_id}", layout: renderer.render(partial: "messages/message", locals: {message: message}), sender_id: sender_id
  end

  private

  def render_message message
    ApplicationController.renderer.render(partial: "messages/message", locals: {message: message})
  end
end
