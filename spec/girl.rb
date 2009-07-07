require "rubygems"
require "factory_girl"
require "digest/md5"

def r
  Digest::MD5.hexdigest(rand.to_s)
end

def factory_location
  l = Location.find_or_create(:name => "San Francisco, CA", :lat => 37.775206, :lng => -122.419209)
  l.save(false) if l.new_record?
  l.update_attribute :geocodable, true
  l
end

Factory.define :user do |user|
  user.name { "Joe #{r}" }
  user.email { "joe_#{r}@example.com" }
  user.password "hiworld"
  user.password_confirmation "hiworld"
  user.default_location factory_location()
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
  trip.locations [factory_location()]
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
  p.location factory_location
  p.radius 10
end

Factory.define :event do |e|
  e.name "Fake event"
  e.description "It's fake!"
  e.creator_id Factory(:user).id
  e.location factory_location()
  e.venue "Your mom's house"
  e.start 24.hours.from_now
  e.finish 26.hours.from_now
  e.guid { rand.to_s }
end

Factory.define :rsvp do |r|
  r.event Factory(:event)
  r.user Factory(:user)
end

Factory.define :eventlet do |e|
  
end