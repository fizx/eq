require File.dirname(__FILE__) + '/../spec_helper'

include ActionController::UrlWriter

describe Interest do
  before do 
    @interest = Interest.random_interest
    @interest.save!
  end
  
  describe "#interval_overlapping_with" do
    before do
      @interest.intervals << Interval.create(:start => Time.now, :finish => 1.week.from_now)
    end
    
    it "should return same intervals" do
      interval = Interval.create(:start => Time.now, :finish => 1.week.from_now)
      Interest.interval_overlapping_with(interval).should == [@interest]
    end
    
    it "should return a partial overlap" do
      interval = Interval.create(:start => 5.days.from_now, :finish => 2.weeks.from_now)
      Interest.interval_overlapping_with(interval).should == [@interest]
    end
    
    it "should return empty if no overlap" do
      interval = Interval.create(:start => 1.year.from_now, :finish => 2.years.from_now)
      Interest.interval_overlapping_with(interval).should == []
    end
    
  end
  
  describe "#of_friends_of" do
    before do
      @joe = Factory(:user, :login => "joe")
      @suzy = Factory(:user, :login => "suzy")
      Following.create_friendship(@joe, @suzy)
      10.times do
        i = Interest.random_interest
        i.save!
        @joe.interests << i
        i.save!
        
        i = Interest.random_interest
        i.save!
        @suzy.interests << i
        i.save! 
      end
      @joe.save!
      @suzy.save!
      @suzy.reload
      @joe.reload
    end
    
    it "should scope to the interests shared by friends" do
      @joe.interests.count.should == 10
      @suzy.interests.count.should == 10
      Interest.of_friends_of(@joe).should == @suzy.interests
    end
  end
  
  describe "#random" do
    it "should be different each time-ish" do
      interests = Array.new(10).map { Interest.random_interest }
      equal_count = 0
      10.times do 
        equal_count += 1 if interests.rand.attributes == interests.rand.attributes
      end
      equal_count.should < 5
    end
  end
end
