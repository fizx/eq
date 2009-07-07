class DatesController < ApplicationController
  def ac
    DateRange.parse(params[:q])
    render :text => "ok"
  rescue
    render :text => "fail"
  end
end
