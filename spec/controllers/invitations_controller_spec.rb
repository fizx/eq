require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvitationsController do

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

  describe "GET edit" do
    it "assigns the requested invitation as @invitation" do
      Invitation.stub!(:find).with("37").and_return(mock_invitation)
      get :edit, :id => "37"
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
        response.should redirect_to(invitation_url(mock_invitation))
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

  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested invitation" do
        Invitation.should_receive(:find).with("37").and_return(mock_invitation)
        mock_invitation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :invitation => {:these => 'params'}
      end

      it "assigns the requested invitation as @invitation" do
        Invitation.stub!(:find).and_return(mock_invitation(:update_attributes => true))
        put :update, :id => "1"
        assigns[:invitation].should equal(mock_invitation)
      end

      it "redirects to the invitation" do
        Invitation.stub!(:find).and_return(mock_invitation(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(invitation_url(mock_invitation))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested invitation" do
        Invitation.should_receive(:find).with("37").and_return(mock_invitation)
        mock_invitation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :invitation => {:these => 'params'}
      end

      it "assigns the invitation as @invitation" do
        Invitation.stub!(:find).and_return(mock_invitation(:update_attributes => false))
        put :update, :id => "1"
        assigns[:invitation].should equal(mock_invitation)
      end

      it "re-renders the 'edit' template" do
        Invitation.stub!(:find).and_return(mock_invitation(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested invitation" do
      Invitation.should_receive(:find).with("37").and_return(mock_invitation)
      mock_invitation.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the invitations list" do
      Invitation.stub!(:find).and_return(mock_invitation(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(invitations_url)
    end
  end

end
