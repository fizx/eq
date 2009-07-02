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

def generate_location
  RAILS_ENV == "test" ? 
  Factory(:location).id : 
  Location.from("100 spear st, sf ca").id
end

Factory.define :user do |user|
  user.login { "joe_#{r}" }
  user.email { "joe_#{r}@example.com" }
  user.password "hiworld"
  user.password_confirmation "hiworld"
  user.default_location_id { generate_location  }
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
  i.user Factory(:user)
  i.activity { Factory(:activity) }
  i.time_span { Factory(:time_span) }
  i.familiarity { Factory(:familiarity) }
  i.group_size { Factory(:group_size) }
  i.proximity { Factory(:proximity) }
end

Factory.define :time_span do |t|
  t.name "this weekend"
end

Factory.define :familiarity do |f|
  f.name "you are friends with"
end

Factory.define :group_size do |g|
  g.name "a small group"
  g.min 2
  g.max 5
end

Factory.define :proximity do |p|
  p.location_id { generate_location }
  p.radius 10
end

Factory.define :eventlet do |e|
  
end