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
  
  include CollapsedRoutes
  collapsed_routes :activities, :time_spans
    
  # filter_parameter_logging :password
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
    interval = { 
              :find => { :conditions => { :intervalable_id => current_user && current_user.id, :intervalable_type => "User" } },
             :create => { :intervalable_id => current_user && current_user.id, :intervalable_type => "User" }
          }
    Invitation.send :with_scope, user do
      WebCalendar.send :with_scope, user do
        Hiding.send :with_scope, user_create do
          Interesting.send :with_scope, user_create do
            BusyInterval.send :with_scope, interval do
              Trip.send :with_scope, interval do
                yield
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
