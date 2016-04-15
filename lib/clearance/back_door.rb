module Clearance
  # Middleware which allows signing in by passing as=USER_ID in a query
  # parameter. If `User#to_param` is overriden you may pass a block to
  # override the default user lookup behaviour
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
  #   # or if `User#to_param` is overridden (to `username` for example):
  #
  #   # config/environments/test.rb
  #   MyRailsApp::Application.configure do
  #     # ...
  #     config.middleware.use Clearance::BackDoor do |username|
  #       User.find_by(username: username)
  #     end
  #     # ...
  #   end
  #
  # Usage:
  #
  #   visit new_feedback_path(as: user)
  class BackDoor
    def initialize(app, &block)
      @app = app
      @block = block
    end

    def call(env)
      sign_in_through_the_back_door(env)
      @app.call(env)
    end

    private

    # @api private
    def sign_in_through_the_back_door(env)
      params = Rack::Utils.parse_query(env["QUERY_STRING"])
      user_param = params["as"]

      if user_param.present?
        user = find_user(user_param)
        env[:clearance].sign_in(user)
      end
    end

    # @api private
    def find_user(user_param)
      if @block
        @block.call(user_param)
      else
        Clearance.configuration.user_model.find(user_param)
      end
    end
  end
end
