class DoctorFaculty < ApplicationRecord
  belongs_to :doctor
  belongs_to :faculty
end
