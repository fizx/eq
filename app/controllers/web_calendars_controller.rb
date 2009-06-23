class WebCalendarsController < ApplicationController
  # GET /web_calendars
  # GET /web_calendars.xml
  def index
    @web_calendars = WebCalendar.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @web_calendars }
    end
  end

  # GET /web_calendars/1
  # GET /web_calendars/1.xml
  def show
    @web_calendar = WebCalendar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @web_calendar }
    end
  end

  # GET /web_calendars/new
  # GET /web_calendars/new.xml
  def new
    @web_calendar = WebCalendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @web_calendar }
    end
  end

  # GET /web_calendars/1/edit
  def edit
    @web_calendar = WebCalendar.find(params[:id])
  end

  # POST /web_calendars
  # POST /web_calendars.xml
  def create
    @web_calendar = WebCalendar.new(params[:web_calendar])

    respond_to do |format|
      if @web_calendar.save
        flash[:notice] = 'WebCalendar was successfully created.'
        format.html { redirect_to(@web_calendar) }
        format.xml  { render :xml => @web_calendar, :status => :created, :location => @web_calendar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @web_calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /web_calendars/1
  # PUT /web_calendars/1.xml
  def update
    @web_calendar = WebCalendar.find(params[:id])

    respond_to do |format|
      if @web_calendar.update_attributes(params[:web_calendar])
        flash[:notice] = 'WebCalendar was successfully updated.'
        format.html { redirect_to(@web_calendar) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @web_calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /web_calendars/1
  # DELETE /web_calendars/1.xml
  def destroy
    @web_calendar = WebCalendar.find(params[:id])
    @web_calendar.destroy

    respond_to do |format|
      format.html { redirect_to(web_calendars_url) }
      format.xml  { head :ok }
    end
  end
end
