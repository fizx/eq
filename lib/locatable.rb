module Locatable
  def location_string
    location.try :name
  end
  
  def location_string=(string)
    self.location = Location.from(string)
  end
end