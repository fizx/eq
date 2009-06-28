class BusyInterval < Interval
  belongs_to :user
  
  def label
    "Busy"
  end
  
  def busy
    true
  end
  
  def location_string
    "N/A"
  end
end