class Trip < Event
  
  before_save :update_self
  
  def update_self
    self.name = "Trip to #{location.try(:name)}"
    self.description = nil
    self.venue = nil
    self.guid ||= "busy#{UUID.new.generate}@eq.com"
    self.activity = nil
  end
end