require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvitationsController do
  
  before do
    login_as Factory(:user)
  end

  def mock_invitation(stubs={})
    @mock_invitation ||= mock_model(Invitation, stubs)
  end
  
  describe "GET index" do
    it "assigns all invitations as @invitations" do
      Invitation.stub!(:find).with(:all).and_return([mock_invitation])
      get :index
      assigns[:invitations].should == [mock_invitation]
    end
  end

  describe "GET show" do
    it "assigns the requested invitation as @invitation" do
      Invitation.stub!(:find).with("37").and_return(mock_invitation)
      get :show, :id => "37"
      assigns[:invitation].should equal(mock_invitation)
    end
  end

  describe "GET new" do
    it "assigns a new invitation as @invitation" do
      Invitation.stub!(:new).and_return(mock_invitation)
      get :new
      assigns[:invitation].should equal(mock_invitation)
    end
  end
  
  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created invitation as @invitation" do
        Invitation.stub!(:new).with({'these' => 'params'}).and_return(mock_invitation(:save => true))
        post :create, :invitation => {:these => 'params'}
        assigns[:invitation].should equal(mock_invitation)
      end

      it "redirects to the created invitation" do
        Invitation.stub!(:new).and_return(mock_invitation(:save => true))
        post :create, :invitation => {}
        response.should redirect_to(invitation_path(mock_invitation))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved invitation as @invitation" do
        Invitation.stub!(:new).with({'these' => 'params'}).and_return(mock_invitation(:save => false))
        post :create, :invitation => {:these => 'params'}
        assigns[:invitation].should equal(mock_invitation)
      end

      it "re-renders the 'new' template" do
        Invitation.stub!(:new).and_return(mock_invitation(:save => false))
        post :create, :invitation => {}
        response.should render_template('new')
      end
    end
    
  end

end
