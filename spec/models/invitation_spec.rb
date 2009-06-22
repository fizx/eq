require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Invitation do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :email => "value for email",
      :message => "value for message"
    }
  end

  it "should create a new instance given valid attributes" do
    Invitation.create!(@valid_attributes)
  end
end
