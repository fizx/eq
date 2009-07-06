# Methods added to this helper will be available to all templates in the application.
require "collapsed_routes"
module ApplicationHelper
  include CollapsedRoutes
  collapsed_routes :activities, :time_spans
  
  def desire(interest)
    user = interest.user
    current = user == current_user
    
    link = current ? link_to("You", "/") : link_to(truncate(user.short_name, :length => 12), user)
    if interest.interestings_count > 0
      link += " <span class=plus>+#{interest.interestings_count}</span> "
    end
    link += (current ? " want " : " wants ")
  end
  
  def rsvp_link(event, status)
    link_to status.to_s, "/rsvp/#{event.id}/#{status}"
  end
  
  def interest_link(interest)
    link_to interest.description, interest_path(interest)
  end
  
  def interesting_link(interest)
    if never = current_user.never(interest)
      link = link_to_remote "unblock", :url => never_path(never, :interest_id => interest.id), :method => :delete, :html => {:class => "interested"}
    else
      link = link_to_remote "block activity", :url => nevers_path(:interest_id => interest.id, :never => {:activity_id => interest.activity_id}), :html => {:class => "interested"}
      
      if current_user.hidden?(interest)
        link += link_to_remote "unhide", :url => hidings_path(:hiding => {:interest_id => interest.id}, :unhide => true), :method => :post, :html => {:class => "interested" }
      else
        link += link_to_remote "hide", :url => hidings_path(:hiding => {:interest_id => interest.id}), :method => :post, :html => {:class => "interested" }
      end
      
    end
    
    if current_user.interesting?(interest)
      link += link_to_remote "I'm not interested", :url => interestings_path(:interesting => {:interest_id => interest.id}, :uninterested => true), :method => :post, :html => {:class => "interested" }
    else
      link += link_to_remote "I'm interested", :url => interestings_path(:interesting => {:interest_id => interest.id}), :method => :post, :html => {:class => "interested" }
    end
    link
  end
  
  def show_hidden_link
    link_to "show hidden/blocked items", params.merge(:show_hidden => true), :class => "show_hidden"  unless params[:show_hidden]
  end
  
  def link_to_organize
    link = link_to "I'm attending", "#", :class => "interested"
  end
  
  def event_link
    "<h2>#{link_to "or add a specific event", new_event_url}</h2>"
  end
end
