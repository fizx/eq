class Proximity < Category
  DEFAULTS = [
    ["in your neighborhood", 0.5],
    ["in your city", 3],
    ["in your county", 10],
    ["in your state", 100]
  ]
  belongs_to :location
  validates_presence_of :radius
  validates_presence_of :location
    
  def location_string=(s)
    self.location = Location.from(s)
  end
  
  def location_string
    location.try(:name)
  end
  
end