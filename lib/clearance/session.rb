require 'clearance/default_sign_in_guard'

module Clearance
  class Session
    def initialize(env)
      @env = env
      @current_user = nil
      @cookies = nil
    end

    def add_cookie_to_headers(headers)
      if cookie_value[:value].present?
        Rack::Utils.set_cookie_header!(
          headers,
          remember_token_cookie,
          cookie_value
        )
      end
    end

    def current_user
      if remember_token.present?
        @current_user ||= user_from_remember_token(remember_token)
      end

      @current_user
    end

    def sign_in(user, &block)
      @current_user = user
      status = run_sign_in_stack

      if status.success?
        cookies[remember_token_cookie] = user && user.remember_token
      else
        @current_user = nil
      end

      if block_given?
        block.call(status)
      end
    end

    def sign_out
      if signed_in?
        current_user.reset_remember_token!
      end

      @current_user = nil
      cookies.delete remember_token_cookie
    end

    def signed_in?
      current_user.present?
    end

    def signed_out?
      ! signed_in?
    end

    private

    def cookies
      @cookies ||= ActionDispatch::Request.new(@env).cookie_jar
    end

    def remember_token
      cookies[remember_token_cookie]
    end

    def remember_token_expires
      if expires_configuration.arity == 1
        expires_configuration.call(cookies)
      else
        warn "#{Kernel.caller.first}: [DEPRECATION] " +
          'Clearance.configuration.cookie_expiration lambda with no parameters ' +
          'has been deprecated and will be removed from a future release. The ' +
          'lambda should accept the collection of previously set cookies.'
        expires_configuration.call
      end
    end

    def remember_token_cookie
      Clearance.configuration.cookie_name.freeze
    end

    def expires_configuration
      Clearance.configuration.cookie_expiration
    end

    def user_from_remember_token(token)
      Clearance.configuration.user_model.where(remember_token: token).first
    end

    def run_sign_in_stack
      @stack ||= initialize_sign_in_guard_stack
      @stack.call
    end

    def initialize_sign_in_guard_stack
      default_guard = DefaultSignInGuard.new(self)
      guards = Clearance.configuration.sign_in_guards

      guards.inject(default_guard) do |stack, guard_class|
        guard_class.new(self, stack)
      end
    end

    def cookie_value
      value = {
        expires: remember_token_expires,
        httponly: Clearance.configuration.httponly,
        path: Clearance.configuration.cookie_path,
        secure: Clearance.configuration.secure_cookie,
        value: remember_token
      }

      if Clearance.configuration.cookie_domain.present?
        value[:domain] = Clearance.configuration.cookie_domain
      end

      value
    end
  end
end
