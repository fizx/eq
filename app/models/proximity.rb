class Proximity < Category
  belongs_to :location
  validates_presence_of :radius
  
  NEIGHBORHOOD = Proximity.find_or_create :name => "in your neighborhood", :radius => 0.5
  CITY = Proximity.find_or_create :name => "in your city", :radius => 3
  COUNTY = Proximity.find_or_create :name => "in your county", :radius => 10
  STATE = Proximity.find_or_create :name => "in your state", :radius => 100
  
  def location_string=(s)
    self.location = Location.from(s)
  end
  
  def location_string
    location.try(:name)
  end
  
end