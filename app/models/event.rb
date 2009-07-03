class Event < ActiveRecord::Base
  belongs_to :location
  has_many :rsvps
  has_many :unresponded_rsvps, :conditions => "type IS NULL", :class_name => "Rsvp"
  has_many :confirmed_rsvps
  has_many :declined_rsvps
  has_many :maybe_rsvps
  belongs_to :creator, :class_name => "User"
  attr_accessor :invited
end
