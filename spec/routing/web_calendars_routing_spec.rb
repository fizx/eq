require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebCalendarsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "web_calendars", :action => "index").should == "/web_calendars"
    end
  
    it "maps #new" do
      route_for(:controller => "web_calendars", :action => "new").should == "/web_calendars/new"
    end
  
    it "maps #show" do
      route_for(:controller => "web_calendars", :action => "show", :id => "1").should == "/web_calendars/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "web_calendars", :action => "edit", :id => "1").should == "/web_calendars/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "web_calendars", :action => "create").should == {:path => "/web_calendars", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "web_calendars", :action => "update", :id => "1").should == {:path =>"/web_calendars/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "web_calendars", :action => "destroy", :id => "1").should == {:path =>"/web_calendars/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/web_calendars").should == {:controller => "web_calendars", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/web_calendars/new").should == {:controller => "web_calendars", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/web_calendars").should == {:controller => "web_calendars", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/web_calendars/1").should == {:controller => "web_calendars", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/web_calendars/1/edit").should == {:controller => "web_calendars", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/web_calendars/1").should == {:controller => "web_calendars", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/web_calendars/1").should == {:controller => "web_calendars", :action => "destroy", :id => "1"}
    end
  end
end
