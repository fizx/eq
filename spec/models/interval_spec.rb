require File.dirname(__FILE__) + '/../spec_helper'

describe Interval do
  it "must have a start before the finish" do
    now = Time.now
    Interval.new(:start => now, :finish => 1.minute.ago).should_not be_valid
    Interval.new(:start => now, :finish => now).should be_valid
    Interval.new(:start => now, :finish => 1.minute.from_now).should be_valid
  end
  
end
