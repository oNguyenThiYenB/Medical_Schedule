class MailCreatedAppointmentJob < ApplicationJob
  queue_as :default

  def perform appointment
    UserMailer.mail_created_appointment(appointment).deliver_now
  end
end
