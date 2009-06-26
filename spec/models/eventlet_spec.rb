require File.dirname(__FILE__) + '/../spec_helper'

describe Eventlet do
  before do 
    @a = Factory(:eventlet, :matcher => "^http://upcoming\\.yahoo\\.com")
    @b = Factory(:eventlet, :matcher => "^http://something")
    @c = Factory(:eventlet, :matcher => "^http://else")
  end
  
  describe "#match" do
    it "should find by regular expression" do
      Eventlet.match("http://else.com/foo").should == @c
    end
    
    it "should return nil on no match" do 
      Eventlet.match("http://google.com").should be_nil
    end
  end
end
