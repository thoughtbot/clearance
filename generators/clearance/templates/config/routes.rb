ActionController::Routing::Routes.draw do |map|
  map.resource  :account
  
  map.root :controller => 'users', :action => 'new'
end
