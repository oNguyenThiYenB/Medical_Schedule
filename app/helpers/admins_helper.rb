module AdminsHelper
  def number_of_statistics table
    table.all.size
  end
end
