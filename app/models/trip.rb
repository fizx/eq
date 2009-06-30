class Trip < Interval
  
  has_many :locations, :through => :locationings
  has_many :locationings, :as => :locatable
  
  validates_each(:locations) do |r,a,v|
    r.errors.add(a, "should exist") unless v.length == 1
  end
  
  def label
    location.try(:name)
  end
  
  def location
    locations.first
  end
  
  def location_string=(s)
    location = Location.from(s)
    locations.clear
    locations << location if location
  end
  
  def location_string
    locations.first.try(:name)
  end
  
end