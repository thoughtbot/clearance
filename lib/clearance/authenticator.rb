module Clearance
  class Authenticator
    def initialize(app)
      @app = app
    end

    def call(env)
      session = Clearance::Session.new(env)
      env_with_clearance = env.merge(:clearance => session)
      response = @app.call(env_with_clearance)
      session.add_cookie_to_headers response[1]
      response
    end
  end
end
