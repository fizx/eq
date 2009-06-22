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
    # it "should not list them as friends" do
    #   @joe.friends.should be_empty
    #   @suzy.friends.should be_empty
    #   @joe.followers.should be_empty
    #   @suzy.followers.should be_empty
    #   @joe.following.should be_empty
    #   @suzy.following.should be_empty
    # end
  end
  
  describe "one-way relationship" do
    before do
      @following = Following.create :follower_id => @joe.id, :followee_id => @suzy.id, :bidi => false
    end
  end
  
  describe "two-way relationship" do
    before do 
      @following = Following.create :follower_id => @joe.id, :followee_id => @suzy.id, :bidi => true
    end
  end
  
end
