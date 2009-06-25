class ActivitiesController < ApplicationController
  def new
    @activities = Category.find(:all, :conditions => {:type => "Activity", :parent_id => params[:parent]}, :limit =>6)
  end
end
