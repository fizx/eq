require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/web_calendars/new.html.erb" do
  include WebCalendarsHelper
  
  before(:each) do
    assigns[:web_calendar] = stub_model(WebCalendar,
      :new_record? => true,
      :url => "value for url",
      :data => "value for data"
    )
  end

  it "renders new web_calendar form" do
    render
    
    response.should have_tag("form[action=?][method=post]", web_calendars_path) do
      with_tag("textarea#web_calendar_url[name=?]", "web_calendar[url]")
      with_tag("textarea#web_calendar_data[name=?]", "web_calendar[data]")
    end
  end
end


