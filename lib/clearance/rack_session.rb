module Clearance
  class RackSession
    def initialize(app)
      @app = app
    end

    def call(env)
      session = Clearance::Session.new(env)
      env[:clearance] = session
      @app.call(env)
    end
  end
end
