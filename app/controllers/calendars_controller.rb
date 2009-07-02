class CalendarsController < ApplicationController
  def index
    @events = current_user.events
    @event = current_user.intervals.find(params[:id]) if params[:id]
    @event ||= Interval.new
  end
  
  def date
    @date = "#{params[:month]}/#{params[:day]}/#{params[:year]}"
    start = Chronic.parse("#{@date} at 0:00")
    finish = Chronic.parse("#{@date} at 24:00")
    interval = Interval.from(start, finish)
    flash.now[:notice] = "You can't plan an event in the past, silly." if start < Time.now
    @activity = Activity.find_by_type_and_name "Activity", params[:activity]
    if !@activity && params[:activity]
      @did_you_mean = Activity.name_similar_to(params[:activity]).first.try :name
    end
    unless params[:location].blank?
      location = Location.from params[:location]
      radius = params[:r].to_f
      radius = [0.2, radius].min
      @proximity = Proximity.find_or_create!(:radius => radius, :location_id => location.id)
    end
    
    @interests = Interest.interval_overlapping_with(interval)
    @interests = @interests.activity_overlapping_with(@activity)    if @activity
    @interests = @interests.proximity_overlapping_with(@proximity)  if @proximity
    @interests = @interests.paginate(:page => params[:page])
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
