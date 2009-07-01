require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  
  describe "#build" do
    it "should not start fresh" do
      a = Factory(:activity)
      Activity.build([])
      Activity.all.should_not be_empty
    end
    
    it "should make the structure" do
      Activity.build(["a", "b", {"c" => ["d", "e"]}])
      c = Activity.find_by_name("c")
      Activity.find_by_name("a").parent.should be_nil
      Activity.find_by_name("b").parent.should be_nil
      c.parent.should be_nil
      Activity.find_by_name("d").parent.should == c
      Activity.find_by_name("e").parent.should == c
    end
  end
end
