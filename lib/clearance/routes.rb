module Clearance
  class Routes

    # In your application's config/routes.rb, draw Clearance's routes:
    #
    # @example
    #   map.resources :posts
    #   Clearance::Routes.draw(map)
    #
    # If you need to override a Clearance route, invoke your app route
    # earlier in the file so Rails' router short-circuits when it finds
    # your route:
    #
    # @example
    #   map.resources :users, :only => [:new, :create]
    #   Clearance::Routes.draw(map)
    def self.draw(map)
      map.resources :passwords,
        :controller => 'clearance/passwords',
        :only       => [:new, :create]

      map.resource  :session,
        :controller => 'clearance/sessions',
        :only       => [:new, :create, :destroy]

      map.resources :users, :controller => 'clearance/users' do |users|
        users.resource :password,
          :controller => 'clearance/passwords',
          :only       => [:create, :edit, :update]

        users.resource :confirmation,
          :controller => 'clearance/confirmations',
          :only       => [:new, :create]
      end

      map.sign_up  'sign_up',
        :controller => 'clearance/users',
        :action     => 'new'
      map.sign_in  'sign_in',
        :controller => 'clearance/sessions',
        :action     => 'new'
      map.sign_out 'sign_out',
        :controller => 'clearance/sessions',
        :action     => 'destroy',
        :method     => :delete
    end

  end
end
