class EventsController < ApplicationController
  def new
    params[:event] ||= {}
    params[:event].delete(:controller)
    params[:event].delete(:action)
    
    params[:event][:start] = Time.at(params[:startms].to_i / 1000) if params[:startms]
    params[:event][:finish] = Time.at(params[:finishms].to_i / 1000) if params[:finishms]
    
    # "/events/new?interest_id="+calEvent.id+"&start="+calEvent.start.getTime()+"&finish="+calEvent.en.getTime()
    @event = Event.new(params[:event])
    
    if params[:interest_id]
      interest = Interest.find params[:interest_id]
      @event.name = interest.activity.name
      @event.category = interest.activity.name
      @event.invited = User.friends_of(current_user).
                            available_at(@event.start).
                            interested_in_attending(interest).
                            all(:select => "users.name").
                            map(&:name).join(", ")
    end
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.save
      @invitees = User.find_all_by_email(params[:event][:invited].split(/\s*[;,\s]\s*/))
      @invitees.map{|i| Rsvp.create :user_id => i, :event_id => @event }
      flash[:notice] = "Your event was created"
      redirect_to @event
    else
      render :action => "new"
    end
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
  def index
    @events = Event.paginate :page => params[:page]
  end

end
