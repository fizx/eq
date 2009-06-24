require File.dirname(__FILE__) + '/../spec_helper'

describe Trip do
  
  it "should have a location" do
    @trip = Factory :trip
    @trip.locations.should_not be_blank
  end
end
