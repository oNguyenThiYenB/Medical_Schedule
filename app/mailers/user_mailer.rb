class UserMailer < ApplicationMailer
  # def account_activation patient
  #   @patient = patient
  #   mail to: patient.email, subject: I18n.t("account_activation")
  # end

  # def password_reset user
  #   @user = user
  #   mail to: user.email, subject: I18n.t("pass_reset")
  # end

  def mail_created_appointment appointment
    @appointment = appointment
    mail to: appointment.patient_email, subject: t("appointment_created_notification")
  end

  def mail_appointment_result appointment
    @appointment = appointment
    mail to: appointment.patient_email, subject: t("mail_appointment_result")
  end

  def mail_incoming_appointment appointment
    @appointment = appointment
    mail to: appointment.patient_email, subject: t("success")
  end
end
