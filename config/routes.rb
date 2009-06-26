ActionController::Routing::Routes.draw do |map|
  map.resources :categories
  map.resources :invitations
  map.resources :busy_intervals
  map.resources :web_calendars
  map.resources :activities do |a|
    a.resources :time_spans do |t|
      t.resources :proximities do |p|
        p.resources :group_sizes do |g|
          g.resources :familiarities
        end
      end
    end
  end
  
  map.resources :trips
  map.resources :calendars
  map.resources :users
  map.resources :intervals
  map.resources :interests
  map.resources :found_email_addresses
  map.resource :session

  map.connect '/destroy_interest/:id', :controller => 'interests', :action => "destroy"
  map.connect "/invitations_autocomplete", :controller => "invitations", :action => "autocomplete"
  map.current_event '/current_event', :controller => 'calendars', :action => "current_event"
  map.friends '/friends/:action', :controller => 'friends'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.root :controller => "home"

end
