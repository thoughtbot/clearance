ActionController::Routing::Routes.draw do |map|
  map.resources :passwords
  map.resource  :session
  map.resources :users, :has_one => [:password, :confirmation]
end
