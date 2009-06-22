require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invitations/edit.html.erb" do
  include InvitationsHelper
  
  before(:each) do
    assigns[:invitation] = @invitation = stub_model(Invitation,
      :new_record? => false,
      :user_id => 1,
      :email => "value for email",
      :message => "value for message"
    )
  end

  it "renders the edit invitation form" do
    render
    
    response.should have_tag("form[action=#{invitation_path(@invitation)}][method=post]") do
      with_tag('input#invitation_user_id[name=?]', "invitation[user_id]")
      with_tag('input#invitation_email[name=?]', "invitation[email]")
      with_tag('textarea#invitation_message[name=?]', "invitation[message]")
    end
  end
end


