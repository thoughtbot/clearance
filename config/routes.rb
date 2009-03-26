ActionController::Routing::Routes.draw do |map|
  map.resources :passwords, :controller => 'clearance/passwords'
  map.resource  :session, :controller => 'clearance/sessions'
  map.resources :users, :controller => 'clearance/users' do |users|
    users.resource :password, :controller => 'clearance/passwords'
    users.resource :confirmation, :controller => 'clearance/confirmations'
  end
end
