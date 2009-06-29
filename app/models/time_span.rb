require "chronic"
class TimeSpan < Category
  THIS_WEEKEND  = TimeSpan.find_or_create_by_name("this weekend")
  ANY_WEEKEND   = TimeSpan.find_or_create_by_name("any weekend")
  MIDWEEK       = TimeSpan.find_or_create_by_name("midweek")
  WHENEVER      = TimeSpan.find_or_create_by_name("whenever")
  
  WEEKS_IN_FUTURE = 20
  
  def intervals
    case self
    when THIS_WEEKEND:
      start = Chronic.parse("this friday at 6pm")
      finish = start + 2.25.days
      [Interval.from(start, finish)]
    when ANY_WEEKEND:      
      start = Chronic.parse("this friday at 6pm")
      finish = start + 2.25.days
      weekly(start, finish)
    when MIDWEEK:       
      start = Chronic.parse("this monday")
      finish = start + 5.days
      weekly(start, finish)
    when WHENEVER:
      [Interval.from(Time.now, 10.years.from_now)]
    end           
  end
  
  def weekly(start, finish)
    Array.new(WEEKS_IN_FUTURE).map do 
      i = Interval.from(start, finish)
      start += 7.days
      finish += 7.days
      i
    end
  end
end