class GroupSizesController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
    @time_span = TimeSpan.find(params[:time_span_id])
    @proximity = Proximity.find(params[:proximity_id])
    @group_sizes = GroupSize.all
  end

end
