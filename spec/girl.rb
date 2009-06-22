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