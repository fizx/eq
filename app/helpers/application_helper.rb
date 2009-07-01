# Methods added to this helper will be available to all templates in the application.
require "collapsed_routes"
module ApplicationHelper
  include CollapsedRoutes
  collapsed_routes :activities, :time_spans
  
  def link_to_interest
    link = link_to "No, thanks", "#", :class => "interested"
    link += link_to "I'm interested", "#", :class => "interested" 
    link
  end
  
  def link_to_organize
    link = link_to "I'm attending", "#", :class => "interested"
  end
  
  def event_link
    "<h2>#{link_to "or add a specific event", new_event_url}</h2>"
  end
end
