require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  describe "#all_roots" do
    it "should include activities without parents" do 
      a = Factory(:activity)
      b = Factory(:activity, :parent => a)
      c = Factory(:activity, :parent => b)
      d = Factory(:activity)
      
      Activity.all_roots.length.should == 2
      Activity.all_roots.should include(a)
      Activity.all_roots.should include(d)
    end
  end
  
  describe "#build" do
    it "should start fresh" do
      a = Factory(:activity)
      Activity.build([])
      Activity.all.should be_empty
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
