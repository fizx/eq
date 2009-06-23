require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/web_calendars/show.html.erb" do
  include WebCalendarsHelper
  before(:each) do
    assigns[:web_calendar] = @web_calendar = stub_model(WebCalendar,
      :url => "value for url",
      :data => "value for data"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ url/)
    response.should have_text(/value\ for\ data/)
  end
end

