require File.dirname(__FILE__) + '/../spec_helper'

describe DateRange do
  describe "#parse" do
    it "should parse a simple range" do
      range = DateRange.parse("jan 1 2009 - dec 12 2009")
      range.first.should == Chronic.parse("jan 1 2009", :guess => false).first
      range.last.should == Chronic.parse("dec 12 2009", :guess => false).last
    end
    
    it "should parse the second in the context of the first" do
      range = DateRange.parse("jan 1 2009 8am-5pm")
      range.first.should == Chronic.parse("jan 1 2009 8am", :guess => false).first
      range.last.should == Chronic.parse("jan 1 2009 5pm", :guess => false).last
    end
  end
  
  describe "#strftime" do
    it "should allow both" do
      range = DateRange.parse("jan 1 2009-jan 1 2015")
      range.strftime("%1Y %2Y").should == "2009 2015"
    end
  end
  
  describe "#to_s" do
    it "should handle same day" do
      DateRange.parse("jan 1 8am-5pm").to_s.should == "Jan  1 8am-5pm"
      DateRange.parse("jan 1 8am-10am").to_s.should == "Jan  1 8-10am"
      DateRange.parse("jan 1 2015 8am-10am").to_s.should == "Jan  1 2015 8-10am"
    end
    
    it "should handle cross days" do
      DateRange.parse("jan 1 2015 8am - jan 2 10am").to_s.should == "Jan  1 2015 8am - Jan  2 2015 10am"
      DateRange.parse("jan 1 8am - jan 2 10am").to_s.should == "Jan  1 8am - Jan  2 10am"
      DateRange.parse("dec 25 2009 8am - jan 2 2010 10am").to_s.should == "Dec 25 8am - Jan  2 10am"
    end
    
    it "should handle minutes" do
      DateRange.parse("aug 25 8pm - 8:30pm").to_s.should == "Aug 25 8-8:30pm"
    end
    
    it "should handle cross months" do
      DateRange.parse("aug 25 - sept 3").to_s.should == "Aug 25 - Sep  3"
    end
  end
end
