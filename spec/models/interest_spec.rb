require File.dirname(__FILE__) + '/../spec_helper'

include ActionController::UrlWriter

describe Interest do
  before do 
    @interest = Interest.random_interest
  end
  
  describe "#random" do
    it "should be different each time-ish" do
      interests = Array.new(10).map { Interest.random_interest }
      equal_count = 0
      10.times do 
        equal_count += 1 if interests.rand.attributes == interests.rand.attributes
      end
      equal_count.should < 5
    end
  end
end
