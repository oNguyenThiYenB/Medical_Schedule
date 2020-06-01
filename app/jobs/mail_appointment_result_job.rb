class MailAppointmentResultJob < ApplicationJob
  queue_as :default

  def perform appointment
    UserMailer.mail_appointment_result(appointment).deliver_now
  end
end
