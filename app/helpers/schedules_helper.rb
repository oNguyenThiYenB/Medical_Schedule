module SchedulesHelper
  def load_schedule
    @appointment&.map do |appointment|
      day = appointment.day.to_s
      start_time = day + " " +
                   I18n.l(appointment.shift_work.start_time, format: :short, locale: :en)
      end_time = day + " " +
                 I18n.l(appointment.shift_work.end_time, format: :short, locale: :en)
      url = patient_path appointment.patient_id
      {
        title: appointment.patient.user_name,
        start: start_time,
        end: end_time,
        url: url
      }
    end
  end
end
