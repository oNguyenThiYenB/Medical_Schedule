module SchedulesHelper
  def modal_status_opt appointment
    arr = [[]]
    if current_user.patient?
      if appointment.may_cancel?
        arr << [t("m_canceled"), "canceled"]
      end
    elsif current_user.doctor?
      t = appointment.shift_work.start_time.time
      d = appointment.day
      appointment_date = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)

      if appointment.may_re_accept?
        arr << [t("m_rejected"), "rejected"]
      end

      if appointment_date < Time.zone.now
        if appointment.may_in_progress?
          arr << [t("m_in_progress"), "in_progress"]
        end
        if appointment.may_finish?
          arr << [t("m_finished"), "finished"]
        end
      end
    end
    return arr
  end

  def form_modal appointment
    s = form_tag(appointment_path(appointment.id), method: :patch) do
      p = hidden_field_tag(:appointment_id, appointment.id)
      p = select_tag(:status, options_for_select(modal_status_opt(appointment)), class: "form-control select_modal_status")
      p << submit_tag(t("save"), class: "submit_modal btn custom_btn btn-size") #(everything will be wrapped in form tag)
      p #returns p from block
    end
    s.html_safe
  end

  def load_schedule
    @appointment&.map do |appointment|
      day = appointment.day.to_s
      start_time = day + " " +
                   I18n.l(appointment.shift_work.start_time, format: :short, locale: :en)
      end_time = day + " " +
                 I18n.l(appointment.shift_work.end_time, format: :short, locale: :en)
      url = appointment_path(appointment.id)

      status = appointment.status
      case status
      when "waiting"
        backgroundColor = '#f3ce13'
      when "accepted"
        backgroundColor = '#3f729b'
      when "rejected"
        backgroundColor = '#6567a5'
      when "canceled"
        backgroundColor = '#cf0005'
      when "in_progress"
        backgroundColor = '#00af81'
      else
        backgroundColor = '#76cc1e'
      end


      if current_user.patient?
        {
          title: t("doctor") + ": " + appointment.doctor.full_name + "\n" + "status: " + status,
          start: start_time,
          end: end_time,
          name: appointment.doctor.full_name,
          room: appointment.doctor.room,
          status: status,
          classNames: ["event_" + status],
          backgroundColor: backgroundColor
        }
      else
        {
          title: t("patient") + ": " + appointment.patient.full_name + "\n" + "status: " + status,
          start: start_time,
          end: end_time,
          modal_title: start_time + ' - ' + end_time,
          patient_name: appointment.patient.full_name,
          patient_birth: appointment.patient.full_name,
          patient_gender: appointment.patient.full_name,
          patient_msg: appointment.patient.full_name,
          doctor_name: appointment.patient.full_name,
          doctor_room: appointment.patient.full_name,
          doctor_position: appointment.patient.full_name,
          doctor_department: appointment.patient.full_name,
          lbl_modal: content_tag( :span, t("#{status}"), class: "label label-#{status}" ),
          modal_form: form_modal(appointment),
          classNames: ["event_" + status],
          backgroundColor: "#3f729b"
        }
      end
    end
  end
end
