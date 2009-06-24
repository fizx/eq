class BusyInterval < Interval
  belongs_to :user
  
  def label
    "Busy"
  end
end