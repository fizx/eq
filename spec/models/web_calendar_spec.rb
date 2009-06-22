require File.dirname(__FILE__) + '/../spec_helper'

describe WebCalendar do
  before do
    @cal_path = File.dirname(__FILE__) + "/../fixtures/basic.ics"
    @user = Factory(:user)
    @cal = Factory(:web_calendar, :user => @user)
    @cal.should_receive(:open_uri).at_least(1).and_return(File.open(@cal_path))
  end
  
  describe "#fetch" do
    before do 
      @cal.fetch
    end
    
    it "should download data" do
      @cal.data.should == File.read(@cal_path)
    end
    
    it "should add busy intervals to user" do
      @user.busy_intervals.should_not be_empty
    end
  end
end
