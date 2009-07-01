class InterestingsController < ApplicationController
  def create
    iid = params[:interesting][:interest_id]
    interest = Interest.find(iid)
    if params[:uninterested]
      @interesting = Interesting.find_by_user_id_and_interest_id(current_user.id, iid)
      @interesting.destroy
      interest.reload
      render_update_item(interest)
    else
      @interesting = Interesting.create(params[:interesting].merge(:user_id => current_user.id))
      interest.reload
      render_update_item(interest)
    end
  end
end