require File.dirname(__FILE__) + '/../spec_helper'

describe WebCalendar do
  before do
    @cal_path = $cal_path = File.dirname(__FILE__) + "/../fixtures/basic.ics"
    @user = Factory(:user)
    
    class ::WebCalendar < Resource
      def open_uri(*args)
        File.open($cal_path)
      end
    end

    @cal = Factory(:web_calendar, :user => @user)
  end
  
  describe "#fetch" do
    before do 
      @cal.fetch
    end
    
    it "should download data" do
      @cal.data.should == File.read(@cal_path)
    end
    
    it "should add events to user" do
      @user.busy_intervals.should be_empty
      @user.events.should_not be_empty
    end
  end
end
