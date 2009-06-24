class BusyIntervalsController < ApplicationController
  def create
    @busy_interval = BusyInterval.new(params[:busy_interval])

    if @busy_interval.save
      flash[:notice] = 'Busy period was successfully created.'
    else
      flash[:notice] = "Error: #{@busy_interval.errors.full_messages.join(", ")}"
    end
    redirect_to url_for(params.merge(:action => "index", :controller => "calendars")) + "#busy"
  end
end
