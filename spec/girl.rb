require "rubygems"
require "factory_girl"
$user_inc = 0
Factory.define :user do |user|
  user.login { "joe_#{$user_inc += 1}" }
  user.email { "joe_#{$user_inc += 1}@example.com" }
  user.password "hiworld"
  user.password_confirmation "hiworld"
end

Factory.define :web_calendar do |cal|
  cal.url "http://www.google.com/calendar/ical/kyle.c.maxwell%40gmail.com/foo/basic.ics"
end

Factory.define :location do |loc|
  loc.name "100 spear st, sf ca"
  loc.lng(-122.394)
  loc.lat(37.79215)
end

Factory.define :trip do |trip|
  trip.start Time.now
  trip.finish 1.week.from_now
  trip.locations [Factory(:location)]
end

Factory.define :activity do |act|
  act.name "something to do"
end

Factory.define :interest do |i|
end

Factory.define :eventlet do |e|
  
end