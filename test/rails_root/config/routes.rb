ActionController::Routing::Routes.draw do |map|

  map.resources :sessions, :users

  map.root :controller => 'sessions', :action => 'new'
  
  map.with_options :controller => 'sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end

end
