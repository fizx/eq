class Event < ActiveRecord::Base
  belongs_to :location
  has_many :rsvps
  has_many :unresponded_rsvps, :conditions => "type IS NULL", :class_name => "Rsvp"
  has_many :confirmed_rsvps
  has_many :declined_rsvps
  has_many :maybe_rsvps
  has_one :interval, :as => :intervalable
  belongs_to :creator, :class_name => "User"
  attr_accessor :invited, :category
  
  def label
    name
  end
  
  named_scope :in_the_future, {
    :joins => "INNER JOIN intervals ON intervalable_type='Event' AND intervalable_id=events.id",
    :conditions => "intervals.start > NOW()"
  }
  
  def startms
    interval.startms
  end
  
  def finishms
    interval.finishms
  end
  
  def self.populate_ical(string)
    
  end
  
  def self.populate_facebook(fb_events)
    fb_events.map do |fb_event|
      event = find_or_initialize_by_guid("#{fb_event.eid}@facebook.com")
      event.name = fb_event.name
      event.interval = Interval.from(Time.at(fb_event.start_time.to_i), Time.at(fb_event.end_time.to_i))
      event.description = fb_event.description
      event.category = "#{fb_event.event_type} / #{fb_event.event_subtype}"
      event.creator = User.find_by_fb_uid(fb_event.creator)
      event.venue = fb_event.location
      event.location = Location.from(fb_event.location) rescue nil
      event.save!
      event
    end
  end
end
