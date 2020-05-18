module FacultiesHelper
  def faculties
    Faculty.pluck :faculty_name, :id
  end
end
