require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  
  describe "#interest_cache" do
    it "should contain tuples" do
      Activity.interest_cache.each do |item| 
        item.length.should == 2
        item.each {|i| i.should_not be_nil}
      end
    end
  end
  
  describe "#activity_overlapping_with" do 
    before do
      @a = Factory(:activity)
      @b = Factory(:activity, :parent => @a)
      @c = Factory(:activity, :parent => @b)
      @d = Factory(:activity, :parent => @c)
      @e = Factory(:activity, :parent => @d)
      @f = Factory(:activity)
    end
    
  end
  
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
