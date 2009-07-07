class BusyEventsController < ApplicationController
  def create
    @busy_event = BusyEvent.new(params[:busy_event])

    if @busy_event.save
      flash[:notice] = 'Busy period was successfully created.'
    else
      flash[:error] = "Error: #{@busy_event.errors.full_messages.join(", ")}"
    end
    redirect_to url_for(params.merge(:action => "index", :controller => "calendars")) + "#busy"
  end
end
