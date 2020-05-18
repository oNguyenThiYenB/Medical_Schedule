module AppointmentHelper
  def doctors
    Doctor.pluck :full_name, :id
  end

  def from_time_all
    ShiftWork.all.map{|i| [I18n.l(i.start_time, format: :short), i.start_time]}
  end

  def earliest_day_register
    Time.zone.today + Settings.limit_day
  end

  def latest_day_register
    Time.zone.today + Settings.max_day
  end
end
