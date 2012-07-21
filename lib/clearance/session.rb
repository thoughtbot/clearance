module Clearance
  class Session
    REMEMBER_TOKEN_COOKIE = 'remember_token'.freeze

    def initialize(env)
      @env = env
    end

    def add_cookie_to_headers(headers)
      if signed_in?
        Rack::Utils.set_cookie_header!(
          headers, REMEMBER_TOKEN_COOKIE,
          :value => current_user.remember_token,
          :expires => Clearance.configuration.cookie_expiration.call,
          :path => '/'
        )
      end
    end

    def current_user
      @current_user ||= with_remember_token do |token|
        Clearance.configuration.user_model.find_by_remember_token token
      end
    end

    def sign_in(user)
      @current_user = user
    end

    def sign_out
      if signed_in?
        current_user.reset_remember_token!
      end

      @current_user = nil
      cookies.delete REMEMBER_TOKEN_COOKIE
    end

    def signed_in?
      current_user.present?
    end

    def signed_out?
      ! signed_in?
    end

    private

    def cookies
      @cookies ||= @env['action_dispatch.cookies'] || Rack::Request.new(@env).cookies
    end

    def remember_token
      cookies[REMEMBER_TOKEN_COOKIE]
    end

    def with_remember_token
      if token = remember_token
        yield token
      end
    end
  end
end
