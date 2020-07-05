class Appointment < ApplicationRecord
  APPOINTMENT_PARAMS = %i(phone_patient address_patient faculty_id doctor_id day shift_work_id have_insurance message status).freeze

  include AASM
  aasm(:status) do
    state :waiting, initial: true
    state :accepted
    state :rejected
    state :canceled
    state :in_progress
    state :finished

    event :accept do
      transitions from: [:waiting], to: :accepted
    end
    event :reject do
      transitions from: [:waiting], to: :rejected
    end
    event :re_accept do
      transitions from: [:accepted], to: :rejected
    end
    event :cancel do
      transitions from: [:accepted], to: :canceled
    end
    event :in_progress do
      transitions from: [:accepted], to: :in_progress
    end
    event :finish do
      transitions from: [:in_progress], to: :finished
    end
    event :waiting do
      transitions from: [:waiting], to: :canceled
    end
  end

  enum status: {waiting: 0, accepted: 1, rejected: 2, canceled: 3, in_progress:4, finished:5}

  belongs_to :patient
  belongs_to :doctor
  belongs_to :faculty
  belongs_to :shift_work
  has_one :medical_record, dependent: :destroy

  validates :phone_patient, presence: true,
    length: {maximum: Settings.max_phone}
  validates :address_patient, presence: true,
    length: {maximum: Settings.max_address}
  validates :day, presence: true

  delegate :full_name, :room, to: :doctor, prefix: true
  delegate :full_name, :email, to: :patient, prefix: true

  scope :by_created_at, ->{order created_at: :asc}
  scope :appointment_exists, (lambda do |doctor_id, day, shift_work_id|
    where("doctor_id = ? and day = ? and shift_work_id = ?",
          doctor_id, day, shift_work_id)
  end)
  scope :find_appointments_by_doctor_id_from_current_date, (lambda do |doctor_id, day|
    where("doctor_id = ? and day >= ?", doctor_id, day)
  end)

  scope :find_appointments_by_doctor_id_and_day, (lambda do |doctor_id, day|
    where("doctor_id = ? and day = ?", doctor_id, day)
  end)

  scope :by_not_status, (lambda do |status|
    where("status not in (?)", status)
  end)
end
