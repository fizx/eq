require File.dirname(__FILE__) + '/../spec_helper'

describe Location do
  it "should auto geocode new locations" do 
    loc = Location.create :name => "100 Spear St, San Francisco, CA 94105, USA"
    loc.lat.should == 37.79215
    loc.lng.should == -122.394
  end
end
