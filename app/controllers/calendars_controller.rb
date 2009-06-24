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
      @event.location_string = params[:selected_location]
      @event.start = params[:selected_start]
      @event.finish = params[:selected_finish]
      if @event.save 
        flash[:notice] = "Event updated"
      else
        flash[:notice] = @event.error_text
      end
    end
    redirect_to :action => "index"
  end
end
