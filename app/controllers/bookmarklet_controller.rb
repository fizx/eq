class BookmarkletController < ApplicationController
  skip_before_filter :login_required
  layout false
  
  def bookmarklet
    @jquery = File.read(RAILS_ROOT + "/public/javascripts/jquery-1.3.2.min.js")
    @eventlet = Eventlet.match(params[:url])
  end
  
  def target
    redirect_to new_event_url(:event => params)
  end
end
