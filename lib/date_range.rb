require "chronic"
class DateRange
  attr_reader :first, :last
  def initialize(range)
    @first = range.first
    @last = range.last
  end
  
  def self.parse(string)
    a, b = string.split(/\-|until|to/i)
    a = Chronic.parse(a, :guess => false).first
    b = Chronic.parse(b, :guess => false, :now => a).last
    new a..b
  end


  # describe "#to_s" do
  #   it "should handle same day" do
  #     DateRange.parse("jan 1 2009 8am-5pm").to_s.should == "Jan 1 8am-5pm"
  #     DateRange.parse("jan 1 2009 8am-10am").to_s.should == "Jan 1 8-10am"
  #     DateRange.parse("jan 1 2015 8am-10am").to_s.should == "Jan 1 2015 8-10am"
  #   end
  #   
  #   it "should handle cross days" do
  #     DateRange.parse("jan 1 2015 8am - jan 2 10am").to_s.should == "Jan 1 2015 8am - Jan 2 2015 10am"
  #     DateRange.parse("jan 1 8am - jan 2 10am").to_s.should == "Jan 1 8am - Jan 2 10am"
  #     DateRange.parse("dec 25 2009 8am - jan 2 2010 10am").to_s.should == "Dec 25 8am - Jan 2 10am"
  #   end
  #   
  #   it "should handle minutes" do
  #     DateRange.parse("aug 25 8pm - 8:30pm").to_s.should == "Aug 25 8-8:30pm"
  #   end
  #   
  #   it "should handle cross months" do
  #     DateRange.parse("aug 25 - sept 3").to_s.should == "Aug 25 - Sep 3"
  #   end
  # end
  # 
  
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
    
    if @first.hour == 0 && @first.min == 0 && @last.hour == 0 && @last.min == 0
      strftime ignore_time(string), @first, @last - 1
    else
      strftime string
    end
  end
  
  def ignore_time(string)
    string.gsub(/\s*(%\d[PMlI])+\s*/, ' ').strip
  end
  
  def strftime(string, first = @first, last = @last)
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