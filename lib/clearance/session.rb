module Clearance
  class Session
    REMEMBER_TOKEN_COOKIE = "remember_token".freeze

    def initialize(env)
      @env = env
    end

    def signed_in?
      current_user.present?
    end

    def current_user
      @current_user ||= with_remember_token do |token|
        Clearance.configuration.user_model.find_by_remember_token(token)
      end
    end

    def sign_in(user)
      @current_user = user
    end

    def sign_out
      current_user.reset_remember_token! if signed_in?
      @current_user = nil
      cookies.delete(REMEMBER_TOKEN_COOKIE)
    end

    def add_cookie_to_headers(headers)
      if signed_in?
        Rack::Utils.set_cookie_header!(headers,
                                       REMEMBER_TOKEN_COOKIE,
                                       :value => current_user.remember_token,
                                       :expires => Clearance.configuration.cookie_expiration.call,
                                       :path => "/")
      end
    end

    private

    def with_remember_token
      if token = remember_token
        yield token
      end
    end

    def remember_token
      cookies[REMEMBER_TOKEN_COOKIE]
    end

    def cookies
      @cookies ||= Rack::Request.new(@env).cookies
    end
  end
end
