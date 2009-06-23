require "open-uri"
require "icalendar"
class WebCalendar < Resource
  belongs_to :user
  
  before_create :fetch
  
  def fetch
    self.data = open_uri(url).read
    cals = Icalendar.parse(data)
    cals.each do |cal|
      cal.events.each do |event|
        BusyInterval.find_or_create_by_user_id_and_start_and_finish user_id, event.start, event.end
      end
    end
  end
  
  def open_uri(path)
    open(path)
  end
end