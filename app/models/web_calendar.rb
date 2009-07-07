require "open-uri"
require "icalendar"
class WebCalendar < Resource
  belongs_to :user
  validates_uniqueness_of :url, :scope => :user_id
  after_create :fetch_later
  
  def fetch_later
    send_later :fetch
  end
  
  def fetch
    self.data = open_uri(url).read
    cals = Icalendar.parse(data)
    cals.each do |cal|
      cal.events.each do |ical_event|
        event = Event.find_or_initialize_by_guid(ical_event.uid)
        event.creator_id ||= User.from_email(ical_event.organizer.try :to)
        event.name = ical_event.summary
        event.description = ical_event.description
        event.venue = ical_event.location
        event.location = Location.from(ical_event.location) rescue nil
        event.interval = Interval.from(ical_event.start, ical_event.end)
        event.save!
        emails = ical_event.attendees.map do |attendee|
          email = attendee.try :to
        end
        Rsvp.confirm_emails event, emails
      end
    end
  end
  
  def status_to_type(status)
    case status
    when "CONFIRMED": "ConfirmedRsvp"
    else 
      nil
    end
  end
  
  def open_uri(path)
    open(path)
  end
end