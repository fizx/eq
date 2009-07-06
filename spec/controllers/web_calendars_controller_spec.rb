require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebCalendarsController do
  
  before do
    login_as Factory(:user)
  end

  def mock_web_calendar(stubs={})
    @mock_web_calendar ||= mock_model(WebCalendar, stubs)
  end
  
  describe "GET new" do
    it "assigns a new web_calendar as @web_calendar" do
      WebCalendar.stub!(:new).and_return(mock_web_calendar)
      get :new
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
        response.should redirect_to(web_calendar_path(mock_web_calendar))
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

  describe "DELETE destroy" do
    it "destroys the requested web_calendar" do
      WebCalendar.should_receive(:find).with("37").and_return(mock_web_calendar)
      mock_web_calendar.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the web_calendars list" do
      WebCalendar.stub!(:find).and_return(mock_web_calendar(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(web_calendars_path)
    end
  end

end
