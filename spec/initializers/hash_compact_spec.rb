require File.dirname(__FILE__) + '/../spec_helper'

describe Hash do
  describe "#hash_compact" do
    before do 
      @original = {
        :a => nil,
        :b => :c,
        :d => :e
      }
    end
    it "should return hash without nil values" do
      @original.hash_compact.should == {:b => :c, :d => :e}
    end
    
    it "should not modify in place" do
      @original.hash_compact.should_not == @original
    end
  end
  
end
