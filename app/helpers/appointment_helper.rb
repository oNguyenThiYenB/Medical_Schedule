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
    ShiftWork.all.map{|i| [I18n.l(i.start_time, format: :short), i.id]}
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

  def gender_select
    Insurance.genders.reduce([]){|a, e| a << [I18n.t((e[0]).to_s), e[0]]}
  end

  def default_insurance attribute
    if current_user.insurances.present?
      insurance = current_user.insurances.last
      case attribute
      when :card_number
        insurance.card_number
      when :date_of_birth
        insurance.date_of_birth.strftime("%d/%m/%Y")
      when :gender
        insurance.gender
      when :start_date
        insurance.start_date.strftime("%d/%m/%Y")
      when :due_date
        insurance.due_date.strftime("%d/%m/%Y")
      end
    else
      return ""
    end
  end

  def check_have_insurance
    return true if current_user&.insurances.present?

    return false
  end
end
