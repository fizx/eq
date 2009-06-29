class ProximitiesController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
    @time_span = TimeSpan.find(params[:time_span_id])
    @proximities = Proximity.all
  end
  
  def create
    if params[:proximity][:location_string] != "Me"
      params[:proximity][:location_id] = Location.from(params[:proximity][:location_string]).try(:id)
    end
    params[:proximity].delete(:location_string)
    
    proximity = Proximity.find_or_initialize(params[:proximity])
    if proximity.new_record?
      proximity.private = true
      proximity.save!
    end
    redirect_to new_activity_time_span_proximity_group_size_url(params[:activity_id], params[:time_span_id], proximity.id)
  end

end
