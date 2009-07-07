# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require "collapsed_routes"
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  before_filter :login_required
  
  before_filter :set_time_zone
  def set_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end
  
  def facebook_session
    session[:facebook_session]
  end

  def facebook_user
    (session[:facebook_session] && session[:facebook_session].session_key) ? session[:facebook_session].user : nil
  end
  
  def update_current_user_data
    if facebook_user && current_user == User.find_by_fb_uid(facebook_user.uid)
      facebook_user.populate(*Facebooker::User::FIELDS)
      data = {
        :user => facebook_user,
        :create_event => facebook_user.has_permission?("create_event"),
        :rsvp_event => facebook_user.has_permission?("rsvp_event"),
        :offline_access => facebook_user.has_permission?("offline_access"),
        :events => facebook_user.events({:start_time => Time.now, :end_time => 1.year.from_now})
      }      
      Event.populate_facebook(data[:events])
      current_user.update_attribute :facebook_data, data
    end
  end
  
  include CollapsedRoutes
  collapsed_routes :activities, :time_spans
    
  filter_parameter_logging :password
  layout "site"
  
  around_filter :user_scope
  
  def render_update_item(item)
    name = item.class.to_s.underscore
    render :update do |page|
      page.replace "#{name}_#{item.id}", :partial => "/#{name.pluralize}/#{name}", :locals => {name.to_sym => item}
    end
  end

  def render_update_hide_item(item)
    name = item.class.to_s.underscore
    render :update do |page|
      page.visual_effect(:fade, "#{name}_#{item.id}")
    end
  end
  
  def user_scope
    user_create = {:create => {:user_id => current_user && current_user.id }}
    user = { 
              :find => { :conditions => { :user_id => current_user && current_user.id } },
           }.merge(user_create)
    user_creator = {:create => {:creator_id => current_user && current_user.id }}
    Invitation.send :with_scope, user do
      Event.send :with_scope, user_creator do
        WebCalendar.send :with_scope, user do
          Hiding.send :with_scope, user_create do
            Interest.send :with_scope, user_create do
              Never.send :with_scope, user_create do
                Interesting.send :with_scope, user_create do
                  BusyEvent.send :with_scope, user_creator do
                    Trip.send :with_scope, user_creator do
                      yield
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  def admin_required
    if current_user.is_a?(AdminUser)
      return true
    else
      redirect_to login_url
      return false
    end
  end
end
