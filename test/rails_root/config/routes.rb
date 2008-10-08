ActionController::Routing::Routes.draw do |map|

  map.resources :users
  map.resource :session
  
  map.resources :users, :has_one => :password
  map.resources :passwords
 
  map.root :controller => 'sessions', :action => 'new'
  
  map.with_options :controller => 'sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end

end
