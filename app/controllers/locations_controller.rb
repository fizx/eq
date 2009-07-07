class LocationsController < ApplicationController
  skip_before_filter :login_required
  def ac
    render :text => Location.valid.name_similar_to(params[:q]).find(:all, :limit => 10).map(&:name).join("\n")
  end

end
