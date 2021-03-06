class ActivitiesController < ApplicationController
  def index
    @upcoming = current_user.rsvps.confirmed.future :include => :event
    @activity = Activity.all.rand
    @invitation_count = current_user.rsvps.unresponded.future.count
    interests = Interest.of_friends_of(current_user)
    interests = Interest.visible_to(current_user) unless params[:show_hidden]
    @stream = interests.paginate(:page => params[:page], :order => "interests.id DESC")
    @mass = interests.with_critical_mass(0.1).paginate(:page => params[:page], :order => "interests.id DESC")
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
