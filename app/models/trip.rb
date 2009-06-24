class Trip < Interval
  validates_each(:locations) do |r,a,v|
    r.errors.add(a, "should exist") unless v.length == 1
  end
  
  def label
    location.try(:name)
  end
  
  def location
    locations.first
  end
end