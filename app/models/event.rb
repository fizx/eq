class Event < ActiveRecord::Base
  include EqTimeHelper
  
  belongs_to :location
  has_many :rsvps
  belongs_to :creator, :class_name => "User"
  attr_accessor :invited, :category
  
  def label
    name
  end
  
  named_scope :future, {
    :conditions => "start > NOW()"
  }
  
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
