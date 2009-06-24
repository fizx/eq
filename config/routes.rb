ActionController::Routing::Routes.draw do |map|
  map.resources :categories
  map.resources :invitations
  map.resources :busy_intervals
  map.resources :web_calendars
  map.resources :activities
  map.resources :friends
  map.resources :trips
  map.resources :calendars
  map.resources :users
  map.resource :session

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.root :controller => "home"

end
