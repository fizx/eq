require "chronic"
class TimeSpan < Category
  THIS_WEEKEND  = TimeSpan.find_or_create :private => false, :name => "this weekend"
  ANY_WEEKEND   = TimeSpan.find_or_create :private => false, :name => "any weekend"
  MIDWEEK       = TimeSpan.find_or_create :private => false, :name => "midweek"
  WHENEVER      = TimeSpan.find_or_create :private => false, :name => "whenever"
  
  WEEKS_IN_FUTURE = 20
  
  DAYS = %w[sun mon tues weds thurs fri sat]
  
  serialize :data
  
  def intervals
    case self
    when THIS_WEEKEND:
      start = Chronic.parse("this friday at 6pm")
      finish = start + 2.25.days
      [Interval.from(start, finish)]
    when ANY_WEEKEND:      
      start = Chronic.parse("this friday at 6pm")
      finish = start + 2.25.days
      weekly(start..finish)
    when MIDWEEK:       
      start = Chronic.parse("this monday")
      finish = start + 5.days
      weekly(start..finish)
    when WHENEVER:
      [Interval.from(Time.now, 10.years.from_now)]
    else
      generate_intervals_from(data)
    end           
  end
  
  def generate_intervals_from(data)
    return unless data && data["time_span"]
    start = Chronic.parse(data["time_span"]["start"] + " at 0:00")
    finish = Chronic.parse(data["time_span"]["finish"] + " at 24:00")
    bounds = start..finish
    times = calculate_ranges data["time_span"]["time"].keys, 24
    days = calculate_ranges data["time_span"]["day"].keys, 6
    if times == [0..24] 
      if days == [0..6]
        [Interval.from(start, finish)]
      else
        out = []
        days.each do |range|
          out += weekly(range, bounds)
        end
        out
      end
    else
      out = []
      times.each do |time_range|
        days.each do |range|
          range.each do |day|
            start = Chronic.parse("#{DAYS[day]} #{time_range.first}:00")
            finish = Chronic.parse("#{time_range.last}:00", :now => start)
            out += weekly(start..finish, bounds)
          end
        end
      end
      out
    end
  end
  
  def calculate_ranges(keys, max)
    slots = Array.new(max)
    keys.each do |key|
      if key.include? "-"
        start, finish = key.split("-").map(&:to_i)
        if finish > start
          start.upto(finish) {|i| slots[i] = true}
        else
          0.upto(finish) {|i| slots[i] = true}
          start.upto(slots.length) {|i| slots[i] = true}
        end
      else
        slots[key.to_i] = true
      end
    end
    
    ranges = []
    first = nil
    slots.each_with_index do |s, i|
      if s
        first ||= i
        if i == slots.length - 1
          ranges << (first..(i))
        end
      else
        if first
          ranges << (first..(i-1))
          first = nil
        end
      end
    end
    ranges
  end
  
  def weekly(range, bounds = (Time.now)..(WEEKS_IN_FUTURE.weeks.from_now))
    s, f = range.first, range.last
    bs, bf = bounds.first, bounds.last
    
    while s > (bs + 7.days)
      s -= 7.days
      f -= 7.days
    end
    
    output = []
    
    while f < bf
      output <<  Interval.from(s, f)
      s += 7.days
      f += 7.days
    end
    output
  end
end