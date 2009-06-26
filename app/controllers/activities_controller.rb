class ActivitiesController < ApplicationController
  def index
    @activities = Category.find(:all, :conditions => {:type => "Activity", :parent_id => params[:parent]}, :limit =>6)
  end
  
  def new
    @parent = Activity.find(params[:parent]) if params[:parent]
    @activities = Category.find(:all, :conditions => {:type => "Activity", :parent_id => params[:parent]}, :limit =>6)
  end
end
