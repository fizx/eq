class TimeSpansController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
    @time_spans = TimeSpan.all
  end
end
