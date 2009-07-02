class InterestsController < ApplicationController
  
  def index
    @positives = current_user.interests.paginate :page => params[:page]
    @nevers = current_user.nevers.all(:limit => 10)
  end
  
  def new
    @interest = Interest.find_or_create!(params[:interest])
    @interest.friendly_interests(current_user).map{|i| current_user.is_interested_in(i)}
    redirect_to @interest
  end
  
  def show
    @interest = Interest.find(params[:id])
    @friends = @interest.friendly_interests(current_user).paginate(:page => params[:page], :order => "interestings_count DESC")
  end
  
  def destroy
    @interest = Interest.find(params[:id])
    @interest.destroy
    flash[:notice] = "We've ignored your previous statement about #{@interest.description}"
    redirect_to "/"
  end

end
