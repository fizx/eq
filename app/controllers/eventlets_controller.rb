class EventletsController < ApplicationController
  # GET /eventlets
  # GET /eventlets.xml
  def index
    @eventlets = Eventlet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @eventlets }
    end
  end

  # GET /eventlets/1
  # GET /eventlets/1.xml
  def show
    @eventlet = Eventlet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @eventlet }
    end
  end

  # GET /eventlets/new
  # GET /eventlets/new.xml
  def new
    @eventlet = Eventlet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @eventlet }
    end
  end

  # GET /eventlets/1/edit
  def edit
    @eventlet = Eventlet.find(params[:id])
  end

  # POST /eventlets
  # POST /eventlets.xml
  def create
    @eventlet = Eventlet.new(params[:eventlet])

    respond_to do |format|
      if @eventlet.save
        flash[:notice] = 'Eventlet was successfully created.'
        format.html { redirect_to(@eventlet) }
        format.xml  { render :xml => @eventlet, :status => :created, :location => @eventlet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @eventlet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /eventlets/1
  # PUT /eventlets/1.xml
  def update
    @eventlet = Eventlet.find(params[:id])

    respond_to do |format|
      if @eventlet.update_attributes(params[:eventlet])
        flash[:notice] = 'Eventlet was successfully updated.'
        format.html { redirect_to(@eventlet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @eventlet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /eventlets/1
  # DELETE /eventlets/1.xml
  def destroy
    @eventlet = Eventlet.find(params[:id])
    @eventlet.destroy

    respond_to do |format|
      format.html { redirect_to(eventlets_url) }
      format.xml  { head :ok }
    end
  end
end
