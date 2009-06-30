require "rubygems"
require "factory_girl"
require "digest/md5"

Factory.define :location do |loc|
  loc.name "100 spear st, sf ca"
  loc.lng(-122.394)
  loc.lat(37.79215)
end

def r
  Digest::MD5.hexdigest(rand.to_s)
end

Factory.define :user do |user|
  
  user.login { "joe_#{r}" }
  user.email { "joe_#{r}@example.com" }
  user.password "hiworld"
  user.password_confirmation "hiworld"
  user.default_location_id {
                            RAILS_ENV == "test" ? 
                            Factory(:location).id : 
                            Location.from("100 spear st, sf ca").id
                          }
  user.time_zone ActiveSupport::TimeZone.us_zones.first
end

Factory.define :web_calendar do |cal|
  cal.url "http://www.google.com/calendar/ical/kyle.c.maxwell%40gmail.com/foo/basic.ics"
end

Factory.define :interval do |interval|
  interval.start Time.now
  interval.finish 1.week.from_now
end

Factory.define :trip do |trip|
  trip.start Time.now
  trip.finish 1.week.from_now
  trip.locations [Factory(:location)]
end

Factory.define :activity do |act|
  act.name "something to do: " + rand.to_s
end

Factory.define :interest do |i|
end

Factory.define :time_span do |t|
end

Factory.define :eventlet do |e|
  
end