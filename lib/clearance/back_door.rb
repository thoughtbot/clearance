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
      unless environment_is_allowed?
        raise error_message
      end

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
      params = Rack::Utils.parse_query(env[Rack::QUERY_STRING])
      user_param = params.delete("as")

      if user_param.present?
        query_string = Rack::Utils.build_query(params)
        env[Rack::QUERY_STRING] = query_string
        env[Rack::RACK_REQUEST_QUERY_STRING] = query_string
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

    # @api private
    def environment_is_allowed?
      allowed_environments.include? Rails.env
    end

    # @api private
    def allowed_environments
      Clearance.configuration.allowed_backdoor_environments || []
    end

    # @api private
    def error_message
      unless allowed_environments.empty?
        <<-EOS.squish
          Can't use auth backdoor outside of
          configured environments (#{allowed_environments.join(", ")}).
        EOS
      else
        "BackDoor auth is disabled."
      end
    end
  end
end
