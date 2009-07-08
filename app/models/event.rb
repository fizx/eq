class Event < ActiveRecord::Base
  include EqTimeHelper
  include Locatable
  
  has_many :rsvps, :include => :user
  accepts_nested_attributes_for :rsvps
  
  belongs_to :location
  belongs_to :activity
  belongs_to :creator, :class_name => "User"
  attr_accessor :invited
  
  def label
    name
  end
  
  def category
    activity.try :name
  end
  
  def category=(str)
    self.activity = Activity.from(str)
  end
  
  named_scope :future, {
    :conditions => "start > NOW()"
  }
  
  def self.populate_facebook(fb_events)
    fb_events.map do |fb_event|
      event = find_or_initialize_by_guid("#{fb_event.eid}@facebook.com")
      event.name = fb_event.name
      event.start = Time.at(fb_event.start_time.to_i)
      event.finish = Time.at(fb_event.end_time.to_i)
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
