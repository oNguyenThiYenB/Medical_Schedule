class Faculty < ApplicationRecord
  has_many :doctor_faculties
  has_many :doctors, through: :doctor_faculties

  validates :faculty_name, presence: true

  scope :order_by_name, ->{order faculty_name: :asc}
end
