class FamiliaritiesController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
    @time_span = TimeSpan.find(params[:time_span_id])
    @proximity = Proximity.find(params[:proximity_id])
    @group_size = GroupSize.find(params[:group_size_id])
    @familiarities = Familiarity.all
  end

end
