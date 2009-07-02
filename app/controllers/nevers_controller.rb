class NeversController < ApplicationController
  
  def new
    @never = Never.find_or_create!(params[:never])
    flash[:unescaped_notice] = "We've recorded that you do not want to #{@never.description}. " +
                      "<a href=\"/destroy_never/#{@never.id}\">undo</a>"
    redirect_to "/"
  end
  
  def destroy
    @never = Never.find(params[:id])
    @never.destroy
    flash[:notice] = "We've ignored your previous statement about #{@never.description}"
    redirect_to "/"
  end
  
end
