require "chronic"
class DateRangeError < RuntimeError; end
class DateRange < Range
  DELIMITER = /\-|until|to/i
  AMPM = /\d\s*(am|pm)/i
  
  def self.parse(string)
    string.gsub!(/,/, ' ')
    first_string, last_string = string.split(DELIMITER)
    
    if last_string && last_string =~ AMPM && !(first_string =~ AMPM)
      first_string += last_string[AMPM, 1]
    end
    
    first_range = Chronic.parse(first_string, :guess => false)
    first_date = first_range.first
    last_date = last_string ? 
                  Chronic.parse(last_string, :guess => false, :now => first_date).last :
                  first_range.last                
    new(first_date, last_date)
  rescue
    raise DateRangeError.new
  end
  
  def to_s
    m1 = first.min == 0 ? "" : ":%1M"
    m2 = last.min == 0 ? "" : ":%2M"
    yr1 = first > 2.months.ago && first < 10.months.from_now ? "" : " %1Y"
    yr2 = last > 2.months.ago && last < 10.months.from_now ? "" : " %2Y"
    string = if first.year == last.year
      if first.month == last.month
        if first.day == last.day
          if first.hour / 12 == last.hour / 12
            "%1b %1e#{yr1} %1l#{m1}-%2l#{m2}%2P"
          else
            "%1b %1e#{yr1} %1l#{m1}%1P-%2l#{m2}%2P"
          end
        end
      end
    end
    
    string ||= "%1b %1e#{yr1} %1l#{m1}%1P - %2b %2e#{yr2} %2l#{m2}%2P"
    
    if self.first.hour == 0 && self.first.min == 0 && self.last.hour == 0 && self.last.min == 0
      off = self.last - 1 
      if off.day == self.first.day && off.month == self.first.month && off.year == self.first.year 
        string = string.split(DELIMITER).first
      end
      strftime ignore_time(string), self.first, off
    else
      strftime string
    end
  end
  
  def ignore_time(string)
    string.gsub(/\s*(%\d[PMlI])+\s*/, ' ').strip
  end
  
  def strftime(string, first = self.first, last = self.last)
    return nil unless string
    string = string.gsub("%2", "%%").gsub("%1", "%")
    string = ext_strftime(first, string)
    string = first.strftime(string)
    string = string.gsub("%2", "%")
    string = ext_strftime(last, string)
    last.strftime string
  end
  
  def ext_strftime(time, string)
    p = time.hour / 12 == 0 ? "am" : "pm"
    l = time.hour % 12
    l = 12 if l == 0
    l = l.to_s
    
    string.gsub(/([^%]|^)%l/, "\\1#{l}").gsub(/([^%]|^)%P/, "\\1#{p}")
  end  
end