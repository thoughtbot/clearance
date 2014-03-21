Rails.application.routes.draw do
  users_controller = Clearance.configuration.users_controller
  passwords_controller = Clearance.configuration.passwords_controller
  sessions_controller = Clearance.configuration.sessions_controller

  resources :passwords,
    controller: passwords_controller,
    only: [:create, :new]

  resource :session,
    controller: sessions_controller,
    only: [:create]

  resources :users,
    controller: users_controller,
    only: Clearance.configuration.user_actions do
      resource :password,
        controller: passwords_controller,
        only: [:create, :edit, :update]
    end

  get '/sign_in' => "#{sessions_controller}#new", as: 'sign_in'
  delete '/sign_out' => "#{sessions_controller}#destroy", as: 'sign_out'

  if Clearance.configuration.allow_sign_up?
    get '/sign_up' => "#{users_controller}#new", as: 'sign_up'
  end
end
