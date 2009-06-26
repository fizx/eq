class ProximitiesController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
    @time_span = TimeSpan.find(params[:time_span_id])
    @proximities = Proximity.all
  end

end
