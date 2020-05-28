class ShiftWork < ApplicationRecord
  has_many :appointments

  scope :by_shift_work_id, (lambda do |shift_work_id|
    where("id not in (?)", shift_work_id)
  end)
end
