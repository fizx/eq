class HidingsController < ApplicationController
  def create
    iid = params[:hiding][:interest_id]
    interest = Interest.find(iid)
    if params[:unhide]
      @hiding = Hiding.find_by_user_id_and_interest_id(current_user.id, iid)
      @hiding.destroy
      render_update_item(interest)
    else
      @hiding = Hiding.create(params[:hiding].merge(:user_id => current_user.id))
      render_update_hide_item(interest)
    end
  end
end
