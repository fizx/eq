require "uuid"
class BusyEvent < Event
  before_save :update_self
  
  def update_self
    self.name = "Busy"
    self.description = nil
    self.location = nil
    self.venue = nil
    self.guid ||= "busy#{UUID.new.generate}@eq.com"
    self.activity = nil
  end
end