class NeversController < ApplicationController
  
  def create
    @interest = Interest.find(params[:interest_id])
    @never = Never.find_or_create!(params[:never])
    render_update_hide_item @interest
  end
  
  def destroy
    @interest = Interest.find(params[:interest_id])
    @never = Never.find(params[:id])
    @never.destroy
    render_update_item @interest
  end
  
end
