require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/web_calendars/index.html.erb" do
  include WebCalendarsHelper
  
  before(:each) do
    assigns[:web_calendars] = [
      stub_model(WebCalendar,
        :url => "value for url",
        :data => "value for data"
      ),
      stub_model(WebCalendar,
        :url => "value for url",
        :data => "value for data"
      )
    ]
  end

  it "renders a list of web_calendars" do
    render
    response.should have_tag("tr>td", "value for url".to_s, 2)
    response.should have_tag("tr>td", "value for data".to_s, 2)
  end
end

