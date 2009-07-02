require File.dirname(__FILE__) + '/../spec_helper'

include ActionController::UrlWriter

describe Interest do
  before do 
    Interest.delete_all
    @interest = Factory(:interest)
  end
  
  describe "#proximity_overlapping_with" do
  end
  
  describe "#activity_overlapping_with" do 
    before do
      @a = Factory(:activity)                     #         a    f
      @b = Factory(:activity, :parent => @a)      #          \
      @c = Factory(:activity, :parent => @b)      #           b
      @d = Factory(:activity, :parent => @b)      #          / \
      @e = Factory(:activity, :parent => @d)      #         c   d
      @f = Factory(:activity)                     #            / 
      @ia = Factory(:interest, :activity => @a)   #           e                   
      @ib = Factory(:interest, :activity => @b)
      @ic = Factory(:interest, :activity => @c)
      @id = Factory(:interest, :activity => @d)
      @ie = Factory(:interest, :activity => @e)
      @if = Factory(:interest, :activity => @f)
      # "a".upto("f") do |c|
      #   puts "@#{c}: " + instance_variable_get("@#{c}").inspect
      #   puts "@i#{c}: " + instance_variable_get("@i#{c}").inspect
      # end
    end                                           
    
    it "should return the ancestors and children" do
      a = Interest.activity_overlapping_with(@a)
      a.length.should == 5
    end
    
    it "should exclude c from d" do
      d = Interest.activity_overlapping_with(@d)
      d.length.should == 4
      d.should_not include(@ic)
    end
    
    it "should exclude c from d" do
      c = Interest.activity_overlapping_with(@c)
      c.length.should == 3
      c.should_not include(@id)
      c.should_not include(@ie)
    end
    
    it "should have f by itself" do
      f = Interest.activity_overlapping_with(@f)
      f.length.should == 1
      f.should == [@if]
    end
  end
  
  describe "#create" do
    before do
      @this = TimeSpan::THIS_WEEKEND
      @any = TimeSpan::ANY_WEEKEND
    end
    
    it "should create intervals for this weekend" do 
      @interest.time_span = @this
      @interest.save!
      @interest.intervals.length.should == 1
    end
    
    it "should create intervals for any weekend" do 
      @interest.time_span = @any
      @interest.save!
      @interest.intervals.length.should == TimeSpan::WEEKS_IN_FUTURE
    end
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
        Factory(:interest, :user => @joe)
        Factory(:interest, :user => @suzy)
      end
      @joe.save!
      @suzy.save!
      @suzy.reload
      @joe.reload
    end
    
    it "should scope to the interests shared by friends" do
      @joe.interests.count.should == 10
      @suzy.interests.count.should == 10
      Set.new(Interest.of_friends_of(@joe)).should == Set.new(@suzy.interests)
    end
  end
end
