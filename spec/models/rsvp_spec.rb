require File.dirname(__FILE__) + '/../spec_helper'

describe Rsvp do
  describe "#future" do
    before do 
      Rsvp.delete_all
      @ea = Factory(:event, :start => 1.week.from_now, :finish => 2.weeks.from_now)
      @eb = Factory(:event, :start => 1.week.ago, :finish => 2.weeks.from_now)
      @ra = Factory(:rsvp, :event => @ea)
      @rb = Factory(:rsvp, :event => @eb)
    end
    
    it "should only select rsvps with start date greater than now" do
      Rsvp.future.count.should == 1
      Rsvp.future.all.should == [@ra]
    end
  end
end
