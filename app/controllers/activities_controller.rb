class ActivitiesController < ApplicationController
  def index
    @events = current_user.events
    @interest = current_user.new_interest
    @stream = Interest.of_friends_of(current_user).paginate(:page => params[:page], :order => "interests.id DESC")
    @activities = Category.find(:all, :conditions => {:private => false, :type => "Activity", :parent_id => params[:parent]}, :limit =>6)
  end
  
  def new
    @parent = Activity.find(params[:parent]) if params[:parent]
    @activities = Category.find(:all, :conditions => {:type => "Activity", :parent_id => params[:parent]}, :limit =>6)
  end
  
  def create
    activity = Activity.find_or_initialize(params[:activity])
    if activity.new_record?
      activity.private = true
      activity.save!
    end
    redirect_to new_time_span_url(activity)
  end
  
  def ac
    render :text => Activity.name_similar_to(params[:q]).find(:all, :limit => 10).map(&:name).join("\n")
  end
end
