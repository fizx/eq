class InterestingsController < ApplicationController
  def create
    iid = params[:interesting][:interest_id]
    interest => Interest.find(iid)
    @hiding = Interesting.create(params[:interesting].merge(:user_id => current_user.id))
    render_update_item(interest)
  end
end