module Locatable
  def location_string
    location.try(:name) || "N/A"
  end
  
  def location_string=(string)
    self.location = Location.from(string)
  end
end