ActionController::Routing::Routes.draw do |map|
  map.resources :users, :has_one => [:password, :confirmation]
  map.resources :passwords
  map.resource  :session
  map.resource  :account
  
  map.root :controller => 'accounts', :action => 'edit'
end
