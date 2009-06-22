require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invitations/index.html.erb" do
  include InvitationsHelper
  
  before(:each) do
    assigns[:invitations] = [
      stub_model(Invitation,
        :user_id => 1,
        :email => "value for email",
        :message => "value for message"
      ),
      stub_model(Invitation,
        :user_id => 1,
        :email => "value for email",
        :message => "value for message"
      )
    ]
  end

  it "renders a list of invitations" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for email".to_s, 2)
    response.should have_tag("tr>td", "value for message".to_s, 2)
  end
end

