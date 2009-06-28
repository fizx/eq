class Interval < ActiveRecord::Base
  validates_presence_of :start
  validates_presence_of :finish
  belongs_to :intervalable, :polymorphic => true
  
  has_many :locations, :through => :locationings
  has_many :locationings, :as => :locatable
  
  validates_each(:start) do |r, a, v|
    if r.start && r.finish && r.start > r.finish
      r.errors.add(a, "must be before the finish")
    end
  end
  
  def location_string=(s)
    location = Location.from(s)
    locations.clear
    locations << location if location
  end
  
  def busy
    nil
  end
  
  def startms
    (start.to_f * 1000).to_i
  end
  
  def finishms
    (finish.to_f * 1000).to_i
  end
  
  def location_string
    locations.first.try(&:name)
  end
end
