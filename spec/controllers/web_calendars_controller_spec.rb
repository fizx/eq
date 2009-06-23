require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebCalendarsController do

  def mock_web_calendar(stubs={})
    @mock_web_calendar ||= mock_model(WebCalendar, stubs)
  end
  
  describe "GET index" do
    it "assigns all web_calendars as @web_calendars" do
      WebCalendar.stub!(:find).with(:all).and_return([mock_web_calendar])
      get :index
      assigns[:web_calendars].should == [mock_web_calendar]
    end
  end

  describe "GET show" do
    it "assigns the requested web_calendar as @web_calendar" do
      WebCalendar.stub!(:find).with("37").and_return(mock_web_calendar)
      get :show, :id => "37"
      assigns[:web_calendar].should equal(mock_web_calendar)
    end
  end

  describe "GET new" do
    it "assigns a new web_calendar as @web_calendar" do
      WebCalendar.stub!(:new).and_return(mock_web_calendar)
      get :new
      assigns[:web_calendar].should equal(mock_web_calendar)
    end
  end

  describe "GET edit" do
    it "assigns the requested web_calendar as @web_calendar" do
      WebCalendar.stub!(:find).with("37").and_return(mock_web_calendar)
      get :edit, :id => "37"
      assigns[:web_calendar].should equal(mock_web_calendar)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created web_calendar as @web_calendar" do
        WebCalendar.stub!(:new).with({'these' => 'params'}).and_return(mock_web_calendar(:save => true))
        post :create, :web_calendar => {:these => 'params'}
        assigns[:web_calendar].should equal(mock_web_calendar)
      end

      it "redirects to the created web_calendar" do
        WebCalendar.stub!(:new).and_return(mock_web_calendar(:save => true))
        post :create, :web_calendar => {}
        response.should redirect_to(web_calendar_url(mock_web_calendar))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved web_calendar as @web_calendar" do
        WebCalendar.stub!(:new).with({'these' => 'params'}).and_return(mock_web_calendar(:save => false))
        post :create, :web_calendar => {:these => 'params'}
        assigns[:web_calendar].should equal(mock_web_calendar)
      end

      it "re-renders the 'new' template" do
        WebCalendar.stub!(:new).and_return(mock_web_calendar(:save => false))
        post :create, :web_calendar => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested web_calendar" do
        WebCalendar.should_receive(:find).with("37").and_return(mock_web_calendar)
        mock_web_calendar.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :web_calendar => {:these => 'params'}
      end

      it "assigns the requested web_calendar as @web_calendar" do
        WebCalendar.stub!(:find).and_return(mock_web_calendar(:update_attributes => true))
        put :update, :id => "1"
        assigns[:web_calendar].should equal(mock_web_calendar)
      end

      it "redirects to the web_calendar" do
        WebCalendar.stub!(:find).and_return(mock_web_calendar(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(web_calendar_url(mock_web_calendar))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested web_calendar" do
        WebCalendar.should_receive(:find).with("37").and_return(mock_web_calendar)
        mock_web_calendar.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :web_calendar => {:these => 'params'}
      end

      it "assigns the web_calendar as @web_calendar" do
        WebCalendar.stub!(:find).and_return(mock_web_calendar(:update_attributes => false))
        put :update, :id => "1"
        assigns[:web_calendar].should equal(mock_web_calendar)
      end

      it "re-renders the 'edit' template" do
        WebCalendar.stub!(:find).and_return(mock_web_calendar(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested web_calendar" do
      WebCalendar.should_receive(:find).with("37").and_return(mock_web_calendar)
      mock_web_calendar.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the web_calendars list" do
      WebCalendar.stub!(:find).and_return(mock_web_calendar(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(web_calendars_url)
    end
  end

end
