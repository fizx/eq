module EqTimeHelper
  def startms
    (start.to_f * 1000).to_i
  end
  
  def finishms
    (finish.to_f * 1000).to_i
  end
  
  def human_range
    if start && finish
      DateRange.new(start, finish).to_s
    else
      nil
    end
  end
  
  def human_range=(str)
    range = DateRange.parse(str)
    self.start = range.first
    self.finish = range.last
  rescue DateRangeError
    self.errors.add(:date, "was not a valid range")
  end

end