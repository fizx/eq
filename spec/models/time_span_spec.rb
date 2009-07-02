require File.dirname(__FILE__) + '/../spec_helper'

describe TimeSpan do
  before do 
    @ts = Factory(:time_span, :name => "random")
  end
  
  describe "#intervals" do
    it "should generate intervals" do
      @ts.data = {"time_span"=> {"start"=>"06/16/2009", 
                                 "finish"=>"06/30/2009", 
                                 "time"=>{"17-21"=>"on"}, 
                                 "day"=>{"0"=>"on"}}}
                                 
      intervals = @ts.intervals
      intervals.length.should == 2
      a, b = intervals
      a.start.should == Chronic.parse("6/21/09 17:00")
      a.finish.should == Chronic.parse("6/21/09 21:00")
      b.start.should == Chronic.parse("6/28/09 17:00")
      b.finish.should == Chronic.parse("6/28/09 21:00")
    end
  end
  
  describe "#calculate_ranges" do
    it "should calculate range" do
      @ts.calculate_ranges(["12-14", "22-1", "21-23"], 24).should == [0..1, 12..14, 21..24]
    end
  end
end
