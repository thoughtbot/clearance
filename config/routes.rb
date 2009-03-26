ActionController::Routing::Routes.draw do |map|
  map.resources :passwords
  map.resource  :session
  map.resources :users, :has_one => [:password] do |users|
    users.resource :confirmation, :controller => 'clearance/confirmations'
  end
end
