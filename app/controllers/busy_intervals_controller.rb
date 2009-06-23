class BusyIntervalsController < ApplicationController
  def index
    @data_url = url_for :action => "data"
  end
  
  def data
    render :text => current_user.busy_intervals.to_xml
  end
end
