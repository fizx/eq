class HidingsController < ApplicationController
  def create
    iid = params[:hiding][:interest_id]
    @hiding = Hiding.create(params[:hiding].merge(:user_id => current_user.id))
    render :update do |page|
      page.visual_effect(:fade, "positive_interest_#{iid}")
    end
  end
end
