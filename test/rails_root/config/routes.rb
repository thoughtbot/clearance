ActionController::Routing::Routes.draw do |map|

  map.resources :users
  map.resource :session
  map.resource :session_mailer_override
  
  map.resources :users, :has_one => :password
  map.resources :users, :has_one => :confirmation

  map.resources :passwords

  map.resource :account
 
  map.root :controller => 'users', :action => 'new'

end
