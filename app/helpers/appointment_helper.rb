module AppointmentHelper
  def doctors
    Doctor.order_by_name.pluck :full_name, :id
  end

  def occupied_full_dates_formated occupied_full_dates
    occupied_full_dates.map do |date|
      date.strftime("%d/%m/%Y")
    end
  end

  def time_format occupied_shift_works_by_day
    occupied_shift_works_by_day.map{|i| [I18n.l(i.start_time, format: :short), i.id]}
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

  def faculties
    Faculty.order_by_name.pluck :faculty_name, :id
  end
end
