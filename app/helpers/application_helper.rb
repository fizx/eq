# Methods added to this helper will be available to all templates in the application.
require "collapsed_routes"
module ApplicationHelper
  include CollapsedRoutes
  
  def link_to_interest
    link = link_to "No, thanks", "#", :class => "interested"
    link += link_to "I'm interested", "#", :class => "interested" 
    link
  end
  def link_to_organize
    link = link_to "I'm attending", "#", :class => "interested"
  end
end
