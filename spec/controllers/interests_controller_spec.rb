require File.dirname(__FILE__) + '/../spec_helper'

describe InterestsController do
  before do 
    @user = Factory(:user)
    login_as @user
    @interest = Interest.random
  end
  
  describe "new" do
    it "should generate the right url" do
      get :new, @interest.url_hash
      @interest.attributes.each do |k, v|
        next if v.nil?
        assigns[:interest].attributes[k].should == v
      end
    end
  end
  
end
