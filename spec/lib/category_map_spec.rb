require File.dirname(__FILE__) + '/../spec_helper'

describe CategoryMap do
  before do 
    @user = Factory(:user)
    30.times do 
      i = Interest.random_interest
      i.type = rand > 0.5 ? "PositiveInterest" : "NegativeInterest"
      i.save!
      @user.interests << i
    end
    @map = CategoryMap.new(@user)
  end
  
  describe "#associations" do
    it "should contain strings" do
      CategoryMap.associations.should == %w[group_size activity proximity time_span familiarity]
    end
  end
  
  describe "#mapping" do 
    it "should rawk" do 
      @map.mapping.should == nil
    end
  end
  
  describe "#get" do
    it "should return an instance of the type" do
      @map.get(:activity).should be_an(Activity)
    end
  end
  
end
