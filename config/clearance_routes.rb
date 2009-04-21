ActionController::Routing::Routes.draw do |map|
  map.resources :passwords,
    :controller => 'clearance_passwords',
    :only => [:new, :create]

  map.resource  :session,
    :controller => 'clearance_sessions',
    :only => [:new, :create, :destroy]

  map.resources :users, :controller => 'clearance_users' do |users|
    users.resource :password,
      :controller => 'clearance_passwords',
      :only => [:create, :edit, :update]

    users.resource :confirmation,
      :controller => 'clearance_confirmations',
      :only => [:new, :create]
  end
end
