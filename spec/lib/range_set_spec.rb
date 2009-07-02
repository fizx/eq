require File.dirname(__FILE__) + '/../spec_helper'

describe RangeSet do
  before do
    @rs = RangeSet.new([9..15, 1..5, 3..7])
  end
  
  describe "#include?" do
    it "should match things in range" do
      @rs.include?(10).should == true
      @rs.include?(5).should == true      
    end
    
    it "should not match things out of range" do
      @rs.include?(100).should == false
      @rs.include?(8).should == false
    end
  end
  
  it "should be an enumerable" do
    @rs.map{|r| r}.should == [1,2,3,4,5,6,7,9,10,11,12,13,14,15]
  end
end
