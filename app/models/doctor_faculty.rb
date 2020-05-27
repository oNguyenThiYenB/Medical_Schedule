class DoctorFaculty < ApplicationRecord
  belongs_to :doctor
  belongs_to :faculty

  scope :find_all_by_faculty_id, (lambda do |faculty_id|
    where("faculty_id = ?", faculty_id)
  end)
end
