class TimeSpansController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
    @time_spans = TimeSpan.find(:all, :conditions => {:type => "TimeSpan", :private => false})
  end
  
  def create
    @time_span = TimeSpan.create(:data => params, :private => true, :name => "in a specific time range")
    redirect_to new_activity_time_span_proximity_url(params[:activity_id], @time_span)
  end
end
