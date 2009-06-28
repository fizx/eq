class LocationsController < ApplicationController
  def ac
    render :text => Location.name_similar_to(params[:q]).find(:all, :limit => 10).map(&:name).join("\n")
  end

end
