class MailIncomingAppointmentJob < ApplicationJob
  queue_as :default

  def perform appointment
    UserMailer.mail_incoming_appointment(appointment).deliver_now
  end
end
