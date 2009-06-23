class BusyIntervalsController < ApplicationController
  def index
    @events = current_user.busy_intervals
  end
  
  def data
    render :text => current_user.busy_intervals.to_xml(:methods => ["startms", "finishms"])
  end
end
