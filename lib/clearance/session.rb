module Clearance
  class Session
    REMEMBER_TOKEN_COOKIE = 'remember_token'.freeze

    def initialize(env)
      @env = env
    end

    def add_cookie_to_headers(headers)
      Rack::Utils.set_cookie_header!(
        headers,
        REMEMBER_TOKEN_COOKIE,
        :value => remember_token,
        :expires => remember_token_expires,
        :secure => Clearance.configuration.secure_cookie,
        :httponly => Clearance.configuration.httponly,
        :path => '/'
      )
    end

    def current_user
      if remember_token.present?
        @current_user ||= user_from_remember_token(remember_token)
      end

      @current_user
    end

    def sign_in(user)
      cookies[REMEMBER_TOKEN_COOKIE] = user && user.remember_token
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

    def remember_token_expires
      if expires_configuration.arity == 1
        expires_configuration.call(cookies)
      else
        expires_configuration.call
      end
    end

    def expires_configuration
      Clearance.configuration.cookie_expiration
    end

    def user_from_remember_token(token)
      Clearance.configuration.user_model.where(remember_token: token).first
    end
  end
end
