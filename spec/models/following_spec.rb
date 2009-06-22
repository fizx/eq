require File.dirname(__FILE__) + '/../spec_helper'

describe Following do
  before do 
    @joe = Factory(:user)
    @suzy = Factory(:user, :login => "suzy")
  end
  
  describe "validity" do
    it "should require both foreign keys" do
      Following.new.should_not be_valid
      Following.new(:follower_id => @joe.id, :followee_id => @suzy.id).should be_valid
    end
  end
  
  describe "no relationship" do
    it "should not list them as friends" do
      @joe.friends.should be_empty
      @suzy.friends.should be_empty
      @joe.followers.should be_empty
      @suzy.followers.should be_empty
      @joe.followees.should be_empty
      @suzy.followees.should be_empty
    end
  end
  
  describe "one-way relationship" do
    before do
      @following = Following.create :follower_id => @joe.id, :followee_id => @suzy.id, :bidi => false
    end
    
    it "should has_many :through" do
      @joe.friends.should be_empty
      @suzy.friends.should be_empty
      @joe.followers.should be_empty
      @suzy.followers.should == [@joe]
      @joe.followees.should == [@suzy]
      @suzy.followees.should be_empty      
    end
    
    it "should have the correct belongs_tos" do
      @following.follower.should == @joe
      @following.followee.should == @suzy
    end
    
    it "should not set bidi" do
      @following.bidi.should == false
    end
    
  end
  
  describe "two-way relationship" do
    before do 
      @following = Following.create! :follower_id => @joe.id, :followee_id => @suzy.id
      @reciprocal = Following.create! :follower_id => @suzy.id, :followee_id => @joe.id
      @following.reload
      @reciprocal.reload
    end

    it "should has_many :through" do
      @joe.friends.should == [@suzy]
      @suzy.friends.should == [@joe]
      @joe.followers.should == [@suzy]
      @suzy.followers.should == [@joe]
      @joe.followees.should == [@suzy]
      @suzy.followees.should == [@joe]      
    end
    
    it "should set bidi" do
      @following.bidi.should == true
      @reciprocal.bidi.should == true
    end
    
    it "should have the correct belongs_tos" do
      @following.follower.should == @joe
      @following.followee.should == @suzy
    end
    
    it "should unset bidi on deletion" do
      @reciprocal.destroy
      @following.reload.bidi.should == false
    end
  end
  
end
