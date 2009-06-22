require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invitations/show.html.erb" do
  include InvitationsHelper
  before(:each) do
    assigns[:invitation] = @invitation = stub_model(Invitation,
      :user_id => 1,
      :email => "value for email",
      :message => "value for message"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ email/)
    response.should have_text(/value\ for\ message/)
  end
end

