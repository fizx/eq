class Event < ActiveRecord::Base
  belongs_to :location
  has_many :rsvps
  has_many :confirmed_rsvps
  has_many :declined_rsvps
  has_many :maybe_rsvps
  attr_accessor :invited
end
