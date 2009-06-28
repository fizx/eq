class ActivitiesController < ApplicationController
  def index
    @interest = current_user.new_interest
    @activities = Category.find(:all, :conditions => {:type => "Activity", :parent_id => params[:parent]}, :limit =>6)
  end
  
  def new
    @parent = Activity.find(params[:parent]) if params[:parent]
    @activities = Category.find(:all, :conditions => {:type => "Activity", :parent_id => params[:parent]}, :limit =>6)
  end
  
  def create
    activity = Activity.find_or_create(params[:activity])
    redirect_to new_time_span_url(activity)
  end
  
  def ac
    render :text => Activity.name_similar_to(params[:q]).find(:all, :limit => 10).map(&:name).join("\n")
  end
end
