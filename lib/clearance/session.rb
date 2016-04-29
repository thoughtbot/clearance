require 'clearance/default_sign_in_guard'

module Clearance
  # Represents a clearance session, ultimately persisted in
  # `request.env[:clearance]` by {RackSession}.
  class Session
    # @param env The current rack environment
    def initialize(env)
      @env = env
      @current_user = nil
      @cookies = nil
    end

    # Called by {RackSession} to add the Clearance session cookie to a response.
    #
    # @return [void]
    def add_cookie_to_headers(headers)
      if cookie_value[:value].present?
        Rack::Utils.set_cookie_header!(
          headers,
          remember_token_cookie,
          cookie_value
        )
      end
    end

    # The current user represented by this session.
    #
    # @return [User, nil]
    def current_user
      if remember_token.present?
        @current_user ||= user_from_remember_token(remember_token)
      end

      @current_user
    end

    # Sign the provided user in, if approved by the configured sign in guards.
    # If the sign in guard stack returns {SuccessStatus}, the {#current_user}
    # will be set and then remember token cookie will be set to the user's
    # remember token. If the stack returns {FailureStatus}, {#current_user} will
    # be nil.
    #
    # In either event, the resulting status will be yielded to a provided block,
    # if provided. See {SessionsController#create} for an example of how this
    # can be used.
    #
    # @param [User] user
    # @yieldparam [SuccessStatus,FailureStatus] status Result of the sign in
    #   operation.
    # @return [void]
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

    # Invalidates the users remember token and removes the remember token cookie
    # from the store. The invalidation of the remember token causes any other
    # sessions that are signed in from other locations to also be invalidated on
    # their next request. This is because all Clearance sessions for a given
    # user share a remember token.
    #
    # @return [void]
    def sign_out
      if signed_in?
        current_user.reset_remember_token!
      end

      @current_user = nil
      cookies.delete remember_token_cookie
    end

    # True if {#current_user} is set.
    #
    # @return [Boolean]
    def signed_in?
      current_user.present?
    end

    # True if {#current_user} is not set
    #
    # @return [Boolean]
    def signed_out?
      ! signed_in?
    end

    private

    # @api private
    def cookies
      @cookies ||= ActionDispatch::Request.new(@env).cookie_jar
    end

    # @api private
    def remember_token
      cookies[remember_token_cookie]
    end

    # @api private
    def remember_token_expires
      expires_configuration.call(cookies)
    end

    # @api private
    def remember_token_cookie
      Clearance.configuration.cookie_name.freeze
    end

    # @api private
    def expires_configuration
      Clearance.configuration.cookie_expiration
    end

    # @api private
    def user_from_remember_token(token)
      Clearance.configuration.user_model.where(remember_token: token).first
    end

    # @api private
    def run_sign_in_stack
      @stack ||= initialize_sign_in_guard_stack
      @stack.call
    end

    # @api private
    def initialize_sign_in_guard_stack
      default_guard = DefaultSignInGuard.new(self)
      guards = Clearance.configuration.sign_in_guards

      guards.inject(default_guard) do |stack, guard_class|
        guard_class.new(self, stack)
      end
    end

    # @api private
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
