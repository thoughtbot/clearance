Rails.application.routes.draw do
  resources :passwords,
    :controller => 'clearance/passwords',
    :only       => [:new, :create]

  resource  :session,
    :controller => 'clearance/sessions',
    :only       => [:new, :create, :destroy]

  resources :users, :controller => 'clearance/users', :only => [:new, :create] do
    resource :password,
      :controller => 'clearance/passwords',
      :only       => [:create, :edit, :update]
  end

  match 'sign_up'  => 'clearance/users#new', :as => 'sign_up'
  match 'sign_in'  => 'clearance/sessions#new', :as => 'sign_in'
  match 'sign_out' => 'clearance/sessions#destroy', :via => :delete, :as => 'sign_out'
end
