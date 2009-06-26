class EventsController < ApplicationController
  def new
    params[:event] ||= {}
    params[:event].delete(:controller)
    params[:event].delete(:action)
    @event = Event.new(params[:event])
  end
  
  def index
    @events = Event.paginate :page => params[:page]
  end

end
