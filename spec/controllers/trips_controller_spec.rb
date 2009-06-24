require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TripsController do
  
  before do
    @user = Factory(:user)
    login_as @user
  end

  describe "#create" do
    it "should create a trip" do
      post :create, :trip => {:location_string => "boulder, co", :start => "6/26/09", :finish => "6/29/09"}
      @trip = assigns[:trip]
      @trip.should_not be_new_record
      @trip.label.should == "boulder, co"
    end
  end
end
