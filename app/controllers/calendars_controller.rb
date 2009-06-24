class CalendarsController < ApplicationController
  def index
    @events = current_user.events
  end
  
  def current_event
    @event = current_user.intervals.find(params[:selected_id])
    case params[:button].strip.downcase
    when "delete": 
      @event.destroy
      flash[:notice] = "Event deleted"
    when "update":
    end
    redirect_to :action => "index"
  end
end
