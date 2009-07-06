require File.dirname(__FILE__) + '/../spec_helper'

describe Following do
  before do 
    @joe = Factory(:user)
    @suzy = Factory(:user, :name => "suzy")
  end
  
  describe "#create_friendship" do
    it "should create the relationship" do
      Following.create_friendship(@joe, @suzy)
      @joe.reload
      @suzy.reload
      @joe.friends.should == [@suzy]
      @suzy.friends.should == [@joe]
    end
  end
  
  describe "#create_follows" do
    it "should create the relationship" do
      Following.create_follows(@joe, @suzy)
      @joe.reload
      @suzy.reload
      @joe.followees.should == [@suzy]
      @suzy.followers.should == [@joe]
    end
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
      Following.create_friendship(@joe, @suzy)
    end

    it "should has_many :through" do
      @joe.friends.should == [@suzy]
      @suzy.friends.should == [@joe]
      @joe.followers.should == [@suzy]
      @suzy.followers.should == [@joe]
      @joe.followees.should == [@suzy]
      @suzy.followees.should == [@joe]      
    end
  end
  
end
