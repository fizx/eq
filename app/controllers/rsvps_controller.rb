class RsvpsController < ApplicationController
  layout "site"
  before_filter :set_user
  # GET /rsvps
  # GET /rsvps.xml
  def index
    @fresh = @user.rsvps.unresponded.future
    @all = @user.rsvps.actioned.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rsvps }
    end
  end

  # GET /rsvps/1
  # GET /rsvps/1.xml
  def show
    @rsvp = Rsvp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rsvp }
    end
  end

  # GET /rsvps/new
  # GET /rsvps/new.xml
  def new
    @rsvp = Rsvp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rsvp }
    end
  end

  # GET /rsvps/1/edit
  def edit
    @rsvp = Rsvp.find(params[:id])
  end

  # POST /rsvps
  # POST /rsvps.xml
  def create
    @rsvp = Rsvp.new(params[:rsvp])

    respond_to do |format|
      if @rsvp.save
        flash[:notice] = 'Rsvp was successfully created.'
        format.html { redirect_to(@rsvp) }
        format.xml  { render :xml => @rsvp, :status => :created, :location => @rsvp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rsvps/1
  # PUT /rsvps/1.xml
  def update
    @event = Event.find(params[:event_id])
    @rsvp = Rsvp.find_or_initialize(:user_id => current_user.id, :event_id => @event.id)
    @rsvp.type = case params[:status]
      when "yes": "ConfirmedRsvp"
      when "no": "DeclinedRsvp"
      when "maybe": "MaybeRsvp"
    end
    @rsvp.save

    redirect_to @event
  end

  # DELETE /rsvps/1
  # DELETE /rsvps/1.xml
  def destroy
    @rsvp = Rsvp.find(params[:id])
    @rsvp.destroy

    respond_to do |format|
      format.html { redirect_to(rsvps_url) }
      format.xml  { head :ok }
    end
  end
  
private 
  def set_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end
end
