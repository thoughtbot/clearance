ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'sessions'
  map.with_options :controller => 'sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end
  map.resource :sessions

end
