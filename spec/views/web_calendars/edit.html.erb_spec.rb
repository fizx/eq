require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/web_calendars/edit.html.erb" do
  include WebCalendarsHelper
  
  before(:each) do
    assigns[:web_calendar] = @web_calendar = stub_model(WebCalendar,
      :new_record? => false,
      :url => "value for url",
      :data => "value for data"
    )
  end

  it "renders the edit web_calendar form" do
    render
    
    response.should have_tag("form[action=#{web_calendar_path(@web_calendar)}][method=post]") do
      with_tag('textarea#web_calendar_url[name=?]', "web_calendar[url]")
      with_tag('textarea#web_calendar_data[name=?]', "web_calendar[data]")
    end
  end
end


