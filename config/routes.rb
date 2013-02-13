Rails.application.routes.draw do
  resources :passwords,
    :controller => 'clearance/passwords',
    :only => [:create, :new]

  resource :session,
    :controller => 'clearance/sessions',
    :only => [:create, :new, :destroy]

  resources :users,
    :controller => 'clearance/users',
    :only => [:create, :new] do
      resource :password,
        :controller => 'clearance/passwords',
        :only => [:create, :edit, :update]
    end

  get '/sign_in' => 'clearance/sessions#new', :as => 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', :as => 'sign_out'
  get '/sign_up' => 'clearance/users#new', :as => 'sign_up'
end
