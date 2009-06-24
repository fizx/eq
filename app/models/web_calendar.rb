require "open-uri"
require "icalendar"
class WebCalendar < Resource
  belongs_to :user
  validates_uniqueness_of :url, :scope => :user_id
  before_create :fetch
  
  def fetch
    self.data = open_uri(url).read
    cals = Icalendar.parse(data)
    cals.each do |cal|
      cal.events.each do |event|
        BusyInterval.find_or_create_by_intervalable_id_and_intervalable_type_and_start_and_finish user_id, "User", event.start, event.end
      end
    end
  end
  
  def open_uri(path)
    open(path)
  end
end