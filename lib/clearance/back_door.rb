module Clearance
  # Middleware which allows signing in by passing as=USER_ID in a query
  # parameter.
  #
  # Designed to eliminate time in integration tests wasted by visiting and
  # submitting the sign in form.
  #
  # Configuration:
  #
  #   # config/environments/test.rb
  #   MyRailsApp::Application.configure do
  #     # ...
  #     config.middleware.use Clearance::BackDoor
  #     # ...
  #   end
  #
  # Usage:
  #
  #   visit new_feedback_path(as: user)
  class BackDoor
    def initialize(app)
      @app = app
    end

    def call(env)
      sign_in_through_the_back_door(env)
      @app.call(env)
    end

    private

    def sign_in_through_the_back_door(env)
      params = Rack::Utils.parse_query(env['QUERY_STRING'])
      user_id = params['as']

      if user_id.present?
        user = Clearance.configuration.user_model.find(user_id)
        env[:clearance].sign_in(user)
      end
    end
  end
end
