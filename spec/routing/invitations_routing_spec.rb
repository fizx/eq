require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvitationsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "invitations", :action => "index").should == "/invitations"
    end
  
    it "maps #new" do
      route_for(:controller => "invitations", :action => "new").should == "/invitations/new"
    end
  
    it "maps #show" do
      route_for(:controller => "invitations", :action => "show", :id => "1").should == "/invitations/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "invitations", :action => "edit", :id => "1").should == "/invitations/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "invitations", :action => "create").should == {:path => "/invitations", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "invitations", :action => "update", :id => "1").should == {:path =>"/invitations/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "invitations", :action => "destroy", :id => "1").should == {:path =>"/invitations/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/invitations").should == {:controller => "invitations", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/invitations/new").should == {:controller => "invitations", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/invitations").should == {:controller => "invitations", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/invitations/1").should == {:controller => "invitations", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/invitations/1/edit").should == {:controller => "invitations", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/invitations/1").should == {:controller => "invitations", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/invitations/1").should == {:controller => "invitations", :action => "destroy", :id => "1"}
    end
  end
end
