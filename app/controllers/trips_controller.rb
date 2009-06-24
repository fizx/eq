class TripsController < ApplicationController
  def create
    location = Location.from(params[:trip].delete(:location_string))
    @trip = BusyInterval.new(params[:trip])
    @trip.locations << location

    if @trip.save
      flash[:notice] = 'Trip was successfully created.'
    else
      flash[:notice] = "Error: #{@trip.errors.full_messages.join(", ")}"
    end
    redirect_to url_for(params.merge(:action => "index", :controller => "calendars")) + "#trip"
  end
end
