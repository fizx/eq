require File.dirname(__FILE__) + '/../spec_helper'

describe Proximity do
  describe "#create" do
    before do
      @prox = Proximity.new
      @loc = factory_location()
    end
    
    it "should take a location" do
      @prox.location = @loc
      @prox.radius = 10
      @prox.save!
      @prox.reload
      @prox.radius.should == 10
      @prox.location.should == @loc
    end
  end
end
