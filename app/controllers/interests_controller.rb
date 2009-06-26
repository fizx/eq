class InterestsController < ApplicationController
  def new
    @klass = params[:negative] ? NegativeInterest : PositiveInterest
    params[:interest].delete(:type)
    @interest = Interest.find_or_create!(params[:interest].update(:user_id => current_user.id))
    @interest.update_attribute :type, @klass.to_s
    @interest = Interest.find(@interest.id)

    if @interest.negative?
      flash[:unescaped_notice] = "We've recorded that you do not want to #{@interest.description}. " +
                      "<a href=\"/destroy_interest/#{@interest.id}\">undo</a>"
      redirect_to "/"
    else
      redirect_to interest_path(@interest)
    end
  end
  
  def show
    @interest = Interest.find(params[:id])
  end
  
  def destroy
    @interest = Interest.find(params[:id])
    @interest.destroy
    flash[:notice] = "We've ignored your previous statement about #{@interest.description}"
    redirect_to "/"
  end

end
