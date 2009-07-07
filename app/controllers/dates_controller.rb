class DatesController < ApplicationController
  def ac
    range = DateRange.parse(params[:q]) unless params[:q].blank?
    render :text => range.to_s
  rescue
    render :text => "don't understand"
  end
end
