module Clearance
  # Rack middleware that manages the Clearance {Session}. This middleware is
  # automatically mounted by the Clearance {Engine}.
  #
  # * maintains the session cookie specified by your {Configuration}.
  # * exposes previously cookied sessions to Clearance and your app at
  #   `request.env[:clearance]`, which {Authentication#current_user} pulls the
  #   user from.
  #
  # @see Session
  # @see Configuration#cookie_name
  #
  class RackSession
    def initialize(app)
      @app = app
    end

    # Reads previously existing sessions from a cookie and maintains the cookie
    # on each response.
    def call(env)
      session = Clearance::Session.new(env)
      env[:clearance] = session
      response = @app.call(env)
      session.add_cookie_to_headers response[1]
      response
    end
  end
end
