require File.dirname(__FILE__) + '/../spec_helper'

describe TimeSpan do
  before do
    @time_span = Factory(:time_span)
  end
  
  it "should accept intervals" do
    @interval = Factory(:interval)
    @time_span.intervals << @interval
    @time_span.save!
    @time_span.reload
    @time_span.intervals.should == [@interval]
  end
end
