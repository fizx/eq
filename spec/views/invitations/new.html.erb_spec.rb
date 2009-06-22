require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invitations/new.html.erb" do
  include InvitationsHelper
  
  before(:each) do
    assigns[:invitation] = stub_model(Invitation,
      :new_record? => true,
      :user_id => 1,
      :email => "value for email",
      :message => "value for message"
    )
  end

  it "renders new invitation form" do
    render
    
    response.should have_tag("form[action=?][method=post]", invitations_path) do
      with_tag("input#invitation_user_id[name=?]", "invitation[user_id]")
      with_tag("input#invitation_email[name=?]", "invitation[email]")
      with_tag("textarea#invitation_message[name=?]", "invitation[message]")
    end
  end
end


