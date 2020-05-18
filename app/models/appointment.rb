class Appointment < ApplicationRecord
  APPOINTMENT_PARAMS = %i(phone_patient address_patient doctor_id day start_time
    end_time message status).freeze

  enum status: {waiting: 0, accept: 1, cancel: 2}

  belongs_to :patient
  belongs_to :doctor

  validates :phone_patient, presence: true,
    length: {maximum: Settings.max_phone}
  validates :address_patient, presence: true,
    length: {maximum: Settings.max_address}
  validates :day, presence: true

  delegate :full_name, :room, to: :doctor, prefix: true
  delegate :full_name, to: :patient, prefix: true

  scope :by_created_at, ->{order created_at: :asc}
  scope :appointment_exists, (lambda do |doctor_id, start_time, day|
    where("doctor_id = ? and day = ? and start_time = ?",
          doctor_id, day, start_time)
  end)
end
