class GroupSizesController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
    @time_span = TimeSpan.find(params[:time_span_id])
    @proximity = Proximity.find(params[:proximity_id])
    @group_sizes = GroupSize.all
  end
  
  def create
    group_size = GroupSize.find_or_initialize(params[:group_size])
    if group_size.new_record?
      group_size.private = true
      group_size.save!
    end
    redirect_to new_activity_time_span_proximity_group_size_familiarity_url(params[:activity_id], params[:time_span_id], params[:proximity_id], group_size.id)
  end
  

end
