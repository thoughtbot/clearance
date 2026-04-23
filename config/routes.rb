if Clearance.configuration.routes_enabled?
  Rails.application.routes.draw do
    resources :passwords,
      controller: "clearance/passwords",
      only: [:create, :new]

    resource :session,
      controller: "clearance/sessions",
      only: [:create]

    resources :users,
      controller: "clearance/users",
      only: Clearance.configuration.user_actions do
        if Clearance.configuration.allow_password_reset?
          resource :password,
            controller: "clearance/passwords",
            only: [:edit, :update]
        end
      end

    get "/sign_in" => "clearance/sessions#new", :as => "sign_in"
    delete "/sign_out" => "clearance/sessions#destroy", :as => "sign_out"

    if Clearance.configuration.allow_sign_up?
      get "/sign_up" => "clearance/users#new", :as => "sign_up"
    end

    resources :passkeys,
      controller: "clearance/passkeys",
      only: [:new, :create]

    resource :passkey_authentication,
      controller: "clearance/passkey_authentications",
      only: [:new, :create]
  end
end
