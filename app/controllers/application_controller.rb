# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  before_filter :login_required

  filter_parameter_logging :password
  layout "site"
  
  around_filter :user_scope
  
  def user_scope
    user = { 
              :find => { :conditions => { :user_id => current_user && current_user.id } },
              :create => {:user_id => current_user && current_user.id }
           }
    interval = { 
              :find => { :conditions => { :intervalable_id => current_user && current_user.id, :intervalable_type => "User" } },
             :create => { :intervalable_id => current_user && current_user.id, :intervalable_type => "User" }
          }
    Invitation.send :with_scope, user do
      WebCalendar.send :with_scope, user do
        BusyInterval.send :with_scope, interval do
          Trip.send :with_scope, interval do
            yield
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
