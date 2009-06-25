class ActivitiesController < ApplicationController
  def new
    @activities = Category.find_all_by_parent_id_and_type(params[:parent], "Activity")
  end
end
