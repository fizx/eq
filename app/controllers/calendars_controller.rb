class CalendarsController < ApplicationController
  def index
    @events = current_user.events(:include => :location)
    @event = current_user.events.find(params[:id]) if params[:id]
    @event ||= Event.new
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
    @event = current_user.events.find(params[:event][:id])
    case params[:button].strip.downcase
    when "delete": 
      Hiding.find_or_create! :user_id => current_user.id, :hidable_id => @event.id, :hidable_type => @event.type
      flash[:notice] = "Event deleted"
    when "update":
      if @event.update_attributes(params[:event])
        flash[:notice] = "Event updated"
      else
        flash[:notice] = @event.error_text
      end
    end
    redirect_to :action => "index"
  end
end
