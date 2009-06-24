require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TripsController do
  
  before do
    @user = Factory :user
    controller.current_user = @user
  end

  describe "#create" do
    # post :create, :trip => {:location_string => "boulder, co", :start => "6/26/09", :finish => "6/29/09"}
    
  end
end
