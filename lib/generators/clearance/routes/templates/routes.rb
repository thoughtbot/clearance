  scope module: :clearance do
    resources :passwords, only: [:create, :new]
    resource :session, controller: :sessions, only: [:create]

    resources :users, only: [:create] do
      resource :password, controller: :passwords, only: [:create, :edit, :update]
    end

    get "/sign_in", to: "sessions#new", as: "sign_in"
    delete "/sign_out", to: "sessions#destroy", as: "sign_out"
    get "/sign_up", to: "users#new", as: "sign_up"
  end
